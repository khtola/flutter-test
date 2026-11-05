class DeliveryStep {
  final String title;
  final String? time;
  final bool done;

  const DeliveryStep({
    required this.title,
    this.time,
    this.done = false,
  });

  factory DeliveryStep.fromJson(Map<String, dynamic> json) {
    return DeliveryStep(
      title: json['title']?.toString() ?? '',
      time: json['time']?.toString(),
      done: json['done'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'done': done,
    };
  }
}

class Delivery {
  final String riderName;
  final String riderPhone;
  final String vehicle;
  final int etaMinutes;
  final String status;
  final List<DeliveryStep> steps;

  const Delivery({
    required this.riderName,
    required this.riderPhone,
    required this.vehicle,
    required this.etaMinutes,
    required this.status,
    this.steps = const [],
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'];
    return Delivery(
      riderName: json['riderName']?.toString() ?? 'Rider',
      riderPhone: json['riderPhone']?.toString() ?? '',
      vehicle: json['vehicle']?.toString() ?? 'Motorbike',
      etaMinutes: json['etaMinutes'] is num
          ? (json['etaMinutes'] as num).toInt()
          : int.tryParse(json['etaMinutes']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? 'pending',
      steps: rawSteps is List
          ? rawSteps
              .whereType<Map>()
              .map((step) => DeliveryStep.fromJson(Map<String, dynamic>.from(step)))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'riderName': riderName,
      'riderPhone': riderPhone,
      'vehicle': vehicle,
      'etaMinutes': etaMinutes,
      'status': status,
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }
}
