from kuksa_client.grpc import VSSClient

with VSSClient('127.0.0.1', 55556) as client:

    for updates in client.subscribe_current_values([
        'Vehicle.Speed',
        'Vehicle.TraveledDistance',
    ]):
        speed_update = updates.get('Vehicle.Speed')
        speed = getattr(speed_update, 'value', None)

        if speed is not None:
            print(f"Speed: {speed}")
        else:
            print("Speed update is not available.")

        traveled_dist =  updates.get('Vehicle.TraveledDistance')
        speed = getattr(traveled_dist, 'value', None)

        if traveled_dist is not None:
            print(f"Traveled Distance: {speed}")
        else:
            print("Traveled Distance update is not available.")

