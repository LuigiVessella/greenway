class NewDeliveryDTO {
    String? sender;
    String? senderAddress;
    String? receiver;
    String? receiverAddress;
    NewCoordinatesDTO? receiverCoordinates;
    String? weightKg;

    NewDeliveryDTO({
      this.sender,
      this.senderAddress,
      this.receiver,
      this.receiverAddress,
      this.receiverCoordinates,
      this.weightKg,
    });

}

class NewCoordinatesDTO {
    String? type;
    List<double>? coordinates;

    NewCoordinatesDTO({
         this.type,
         this.coordinates,
    });
}
