document.addEventListener('DOMContentLoaded', function () {
    // Select all elements that should trigger the modal
    // We target the image wrapper so clicking the image opens the details
    const roomTriggers = document.querySelectorAll('.room-card .room-img-wrapper');

    roomTriggers.forEach(trigger => {
        trigger.addEventListener('click', function () {
            // Find the parent card to get data attributes
            const card = this.closest('.room-card');

            if (!card) return;

            // Extract data from data attributes
            const type = card.dataset.roomType;
            const price = card.dataset.price;
            const description = card.dataset.description;
            const imageUrl = card.dataset.imageUrl;
            const capacity = card.dataset.capacity;
            const checkIn = card.dataset.checkIn;
            const checkOut = card.dataset.checkOut;

            // Populate Modal Elements
            document.getElementById('roomModalLabel').textContent = type;
            document.getElementById('modalMainImage').src = imageUrl;
            document.getElementById('roomModalBodyContent').innerHTML = `
                <div class="row">
                    <div class="col-md-8">
                        <h4 class="mb-3">Description</h4>
                        <p>${description}</p>
                        <hr>
                        <h5 class="mb-3">Room Features</h5>
                        <ul class="list-unstyled row">
                            <li class="col-6 mb-2"><i class="bi bi-people-fill text-primary me-2"></i> Capacity: ${capacity} Persons</li>
                            <li class="col-6 mb-2"><i class="bi bi-currency-dollar text-primary me-2"></i> Price: $${price} / night</li>
                            <li class="col-6 mb-2"><i class="bi bi-clock-fill text-primary me-2"></i> Check-in: ${checkIn}</li>
                            <li class="col-6 mb-2"><i class="bi bi-clock-history text-primary me-2"></i> Check-out: ${checkOut}</li>
                        </ul>
                    </div>
                    <div class="col-md-4 bg-light p-3 rounded">
                        <h5 class="mb-3 text-center">Book Your Stay</h5>
                        <p class="small text-muted text-center">Best rates guaranteed when booking directly.</p>
                    </div>
                </div>
            `;

            // Update Book Now button in modal
            const bookBtn = document.getElementById('modalBookBtn');
            bookBtn.href = `booking.jsp?room_type=${encodeURIComponent(type)}`;

            // Show the modal
            const modal = new bootstrap.Modal(document.getElementById('roomDetailsModal'));
            modal.show();
        });
    });
});
