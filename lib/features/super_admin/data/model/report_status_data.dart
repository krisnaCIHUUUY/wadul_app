
class ReportStatusData {
  final int verifying; 
  final int inProgress; 
  final int approved; 
  final int rejected; 
  final int total;

  ReportStatusData({
    required this.verifying,
    required this.inProgress,
    required this.approved,
    required this.rejected,
  }) : total = verifying + inProgress + approved + rejected;
}
