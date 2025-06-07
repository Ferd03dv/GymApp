// ignore_for_file: file_names

class Schede {
  final List<dynamic> esercizi;
  final String nomeScheda;
  final String scadenza;
  final String schedaId;
  final bool schedaPred;
  final String userId;

  Schede({
    required this.esercizi,
    required this.nomeScheda,
    required this.scadenza,
    required this.schedaId,
    required this.schedaPred,
    required this.userId,
  });
}

class SchedePredefinite {
  final List<dynamic> esercizi;
  final String nomeScheda;
  final String scadenza;
  final String schedaId;
  final bool schedaPred;
  final List<dynamic> userIds;

  SchedePredefinite({
    required this.esercizi,
    required this.nomeScheda,
    required this.scadenza,
    required this.schedaId,
    required this.schedaPred,
    required this.userIds,
  });
}
