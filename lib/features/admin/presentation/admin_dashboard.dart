import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final List<String> _statuses = [
    'pending',
    'in_progress',
    'disetujui',
    'rejected',
  ];

  bool _loadingRole = true;
  bool _isAdmin = false;
  String? _currentUid;

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    setState(() => _loadingRole = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) Navigator.pushReplacementNamed(context, '/');
      return;
    }
    _currentUid = user.uid;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      final role = data != null ? (data['role'] as String?) : null;
      setState(() {
        _isAdmin = (role == 'admin');
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membaca role: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingRole = false);
    }
  }

  Future<bool> _ensureAdmin() async {
    if (!_loadingRole && _isAdmin) return true;
    if (_loadingRole) await _checkRole();
    if (!_isAdmin) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Akses ditolak — Anda bukan admin.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
    return true;
  }

  Future<void> _updateReportWithNote(
    String docId,
    Map<String, dynamic> updates, {
    Map<String, dynamic>? adminNote,
  }) async {
    final ok = await _ensureAdmin();

    if (!ok) return;

    final ref = FirebaseFirestore.instance.collection('reports').doc(docId);

    try {
      final Map<String, dynamic> topLevel = Map.from(updates);
      topLevel['updatedAt'] = FieldValue.serverTimestamp();

      if (adminNote != null) {
        final safeNote = Map<String, dynamic>.from(adminNote);
        final dynamic atVal = safeNote['at'];
        if (atVal == null || atVal is FieldValue) {
          safeNote['at'] = Timestamp.fromDate(DateTime.now());
        }

        // final user = FirebaseAuth.instance.currentUser;
        // log('current UID: ${user?.uid}');

        // final doc = await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(user!.uid)
        //     .get();
        // log('users doc exists: ${doc.exists}, data: ${doc.data()}');

        await ref.update({
          ...topLevel,
          'adminNotes': FieldValue.arrayUnion([safeNote]),
        });
      } else {
        await ref.update(topLevel);
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Perubahan berhasil disimpan')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan perubahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
        log(e.toString());
      }
    }
  }

  Future<void> _deleteReport(String docId) async {
    final ok = await _ensureAdmin();
    if (!ok) return;
    try {
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(docId)
          .delete();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Laporan dihapus')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus laporan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportsRef = FirebaseFirestore.instance
        .collection('reports')
        .orderBy('tanggal', descending: true);

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh role',
            icon: Icon(Icons.refresh),
            onPressed: _checkRole,
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/onboarding');
              }
            },
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _loadingRole
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: reportsRef.snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snap.hasData || snap.data!.docs.isEmpty) {
                  return Center(child: Text('Belum ada laporan.'));
                }
                final docs = snap.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final doc = docs[i];
                    final data = doc.data() as Map<String, dynamic>;
                    final status = (data['status'] as String?) ?? 'pending';
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: ListTile(
                        title: Text(data['judul'] ?? 'Tanpa judul'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['deskripsi'] ?? ''),
                            SizedBox(height: 6),
                            Text('Status: $status'),
                            if (data['instansiId'] != null)
                              Text('Instansi: ${data['instansiId']}'),
                            if (data['kategori'] != null)
                              Text('Kategori: ${data['kategori']}'),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content: Text(
                                    'Hapus laporan ini? Tindakan tidak bisa dibatalkan.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) await _deleteReport(doc.id);
                            } else if (value == 'open') {
                              _openDetail(context, doc.id, data);
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(value: 'open', child: Text('Buka')),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _showQuickEditor(context, doc.id, data),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _openDetail(BuildContext context, String id, Map<String, dynamic> data) {
    final adminNotes = (data['adminNotes'] as List?) ?? [];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(data['judul'] ?? 'Detail Laporan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((data['buktiFotoURL'] as List?)?.isNotEmpty == true) ...[
                Text('Bukti Foto:'),
                SizedBox(height: 8),
                for (var img in (data['buktiFotoURL'] as List))
                  Image.network(img, height: 120),
                SizedBox(height: 8),
              ],
              Text(data['deskripsi'] ?? ''),
              SizedBox(height: 12),
              Text('Status: ${data['status'] ?? 'pending'}'),
              SizedBox(height: 12),
              Text(
                '--- Catatan Admin ---',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (adminNotes.isEmpty) Text('Belum ada catatan dari admin.'),
              for (var note in adminNotes.reversed)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note['text'] ?? ''),
                      SizedBox(height: 4),
                      Text(
                        'Oleh: ${note['by'] ?? '-'} · ${_formatTimestamp(note['at'])}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic ts) {
    try {
      if (ts == null) return '-';
      if (ts is Timestamp) return ts.toDate().toString();
      return ts.toString();
    } catch (_) {
      return '-';
    }
  }

  void _showQuickEditor(
    BuildContext context,
    String docId,
    Map<String, dynamic> data,
  ) {
    String currentStatus = (data['status'] as String?) ?? 'pending';
    final assignController = TextEditingController(
      text: data['assignedTo'] ?? '',
    );
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (ctx2, setState2) {
              final List<String> localItems = List<String>.from(_statuses);
              if (!localItems.contains(currentStatus)) {
                localItems.insert(0, currentStatus);
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Laporan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  IgnorePointer(
                    ignoring: !_isAdmin,
                    child: Opacity(
                      opacity: _isAdmin ? 1.0 : 0.6,
                      child: Column(
                        children: [
                          DropdownButton<String>(
                            value: localItems.contains(currentStatus)
                                ? currentStatus
                                : null,
                            hint: Text(currentStatus),
                            isExpanded: true,
                            items: localItems
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setState2(() => currentStatus = v!);
                            },
                          ),
                          TextField(
                            controller: assignController,
                            decoration: InputDecoration(
                              labelText: 'Assign ke (instansiId atau uid)',
                            ),
                          ),
                          TextField(
                            controller: noteController,
                            decoration: InputDecoration(
                              labelText:
                                  'Catatan/komentar untuk disimpan (opsional)',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: !_isAdmin
                            ? null
                            : () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text('Konfirmasi Simpan'),
                                    content: Text(
                                      'Simpan perubahan status dan assign?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text('Simpan'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed != true) return;

                                final updates = {
                                  'status': currentStatus,
                                  'assignedTo': assignController.text.trim(),
                                  'updatedAt': FieldValue.serverTimestamp(),
                                  'updatedBy': _currentUid,
                                };

                                Map<String, dynamic>? adminNote;
                                if (noteController.text.trim().isNotEmpty) {
                                  adminNote = {
                                    'text': noteController.text.trim(),
                                    'by': _currentUid,
                                    'at': FieldValue.serverTimestamp(),
                                  };
                                }

                                await _updateReportWithNote(
                                  docId,
                                  updates,
                                  adminNote: adminNote,
                                );
                                if (mounted) Navigator.pop(context);
                              },
                        child: Text('Simpan'),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: !_isAdmin
                            ? null
                            : () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text('Konfirmasi Hapus'),
                                    content: Text('Hapus laporan ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await _deleteReport(docId);
                                  if (mounted) Navigator.pop(ctx);
                                }
                              },
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (!_isAdmin) ...[
                    SizedBox(height: 8),
                    Text(
                      'Hanya admin yang dapat mengubah status atau menghapus laporan.',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 8),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }
}
