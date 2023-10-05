class Season {
  const Season(this.startDate, this.endDate,
      {required this.id, required this.seasonTitle});
  final int id;
  final String seasonTitle;
  final DateTime startDate;
  final DateTime endDate;
}
