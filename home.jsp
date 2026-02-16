<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Welcome to Ocean View Resort</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <!-- Google Fonts -->
        <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@300;400;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="css/style.css">
        <style>
            /* Minimal overrides that might be needed, currently empty as we moved to style.css */
        </style>
    </head>

    <body>

        <!-- Navigation -->
        <jsp:include page="public-navbar.jsp" />

        <!-- Hero Section -->
        <header class="hero-section">
            <div class="container hero-content">
                <h1 class="display-3 fw-bold">Experience Paradise</h1>
                <p class="lead mb-4">Escape to Ocean View Resort, where luxury meets the soothing rhythm of the waves.
                    Your perfect vacation awaits.</p>
                <a href="#rooms" class="btn btn-primary btn-lg px-5 py-3 rounded-pill fw-bold">Book Your Stay</a>
            </div>
        </header>

        <!-- Features Section -->
        <section class="py-5">
            <div class="container text-center">
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="p-3">
                            <i class="bi bi-umbrella feature-icon"></i>
                            <h4 class="mt-4">Private Beaches</h4>
                            <p>Enjoy exclusive access to our pristine white sandy beaches and crystal clear waters.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3">
                            <i class="bi bi-cup-hot feature-icon"></i>
                            <h4 class="mt-4">Gourmet Dining</h4>
                            <p>Savor world-class cuisine at our award-winning restaurants and seaside bars.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3">
                            <i class="bi bi-stars feature-icon"></i>
                            <h4 class="mt-4">World-Class Spa</h4>
                            <p>Rejuvenate your body and mind with our premium spa treatments and wellness centers.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- About Us Section -->
        <section id="about" class="py-5">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6 mb-4 mb-lg-0">
                        <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                            alt="About Ocean View Resort" class="img-fluid rounded shadow-lg"
                            style="border: 2px solid var(--glass-border);">
                    </div>
                    <div class="col-lg-6 pl-lg-5">
                        <h2 class="display-5 fw-bold mb-4">About Us</h2>
                        <h4 class="text-primary mb-3">A Tradition of Luxury and Hospitality</h4>
                        <p class="lead text-muted mb-4">
                            Founded in 2024, Ocean View Resort has established itself as the premier
                            destination for travelers seeking an escape from the ordinary. Nestled on
                            the pristine shores of Tropical Island, we offer more than just a place to
                            stay—we offer an experience.
                        </p>
                        <p class="text-secondary mb-4">
                            Ours dedicated team of professionals is committed to ensuring every moment of
                            your stay is perfect. From our world-class culinary experiences to our
                            rejuvenating spa treatments, every detail is curated for your relaxation and
                            enjoyment.
                        </p>
                        <a href="#contact" class="btn btn-outline-primary rounded-pill px-4">Contact Us</a>
                    </div>
                </div>
            </div>
        </section>

        <!-- Rooms Section -->
        <section id="rooms" class="py-5">
            <div class="container">
                <div class="text-center mb-5">
                    <h2 class="display-5 fw-bold">Our Accommodations</h2>
                    <div class="mx-auto bg-primary" style="height: 3px; width: 100px;"></div>
                    <p class="mt-3 text-muted">Choose the perfect space for your relaxation</p>
                </div>

                <div class="row g-4">
                    <!-- Single Room -->
                    <div class="col-lg-4 col-md-6">
                        <div class="card room-card h-100" data-room-type="Single" data-price="5,000"
                            data-description="Perfect for solo travelers or business trips. Enjoy a cozy atmosphere with all modern amenities and a beautiful garden view. Features a comfortable single bed, workspace, and en-suite bathroom."
                            data-capacity="1" data-check-in="14:00" data-check-out="11:00"
                            data-image-url="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                            data-images="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80,https://images.unsplash.com/photo-1598928506311-c55ded91a20c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80,https://images.unsplash.com/photo-1505693416388-b034631ac954?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80">

                            <div class="room-img-wrapper" style="cursor: pointer;">
                                <img src="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                                    alt="Single Room">
                                <div class="price-badge">$5,000 / night</div>
                                <div class="overlay d-flex align-items-center justify-content-center">
                                    <span class="btn btn-light rounded-pill"><i class="bi bi-eye"></i> View
                                        Details</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h3 class="card-title h4">Single Room</h3>
                                <div class="mb-3 text-warning">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star"></i>
                                    <i class="bi bi-star"></i>
                                </div>
                                <p class="card-text text-muted flex-grow-1">Perfect for solo travelers or business
                                    trips. Enjoy a cozy atmosphere...</p>
                                <ul
                                    class="list-unstyled text-secondary mb-4 list-group list-group-flush list-group-horizontal-sm flex-wrap">
                                    <li class="me-3 mb-2"><i class="bi bi-wifi me-1"></i> Free Wifi</li>
                                    <li class="me-3 mb-2"><i class="bi bi-tv me-1"></i> Smart TV</li>
                                    <li class="me-3 mb-2"><i class="bi bi-wind me-1"></i> AC</li>
                                </ul>
                                <a href="booking.jsp?room_type=Single"
                                    class="btn btn-outline-primary w-100 mt-auto">Book Now</a>
                            </div>
                        </div>
                    </div>

                    <!-- Double Room -->
                    <div class="col-lg-4 col-md-6">
                        <div class="card room-card h-100 border-primary border-2" data-room-type="Double"
                            data-price="8,500"
                            data-description="Ideal for couples or friends. Spacious room with a king-size bed, private balcony, and stunning ocean views. Includes a mini-bar and premium toiletries."
                            data-capacity="2" data-check-in="14:00" data-check-out="11:00"
                            data-image-url="https://images.unsplash.com/photo-1611892440504-42a792e24d32?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                            data-images="https://images.unsplash.com/photo-1611892440504-42a792e24d32?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80,https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80,https://images.unsplash.com/photo-1566665797739-1674de7a421a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80">

                            <div class="position-absolute top-0 start-50 translate-middle badge rounded-pill bg-primary px-3 py-2 shadow"
                                style="z-index: 2;">POPULAR</div>
                            <div class="room-img-wrapper" style="cursor: pointer;">
                                <img src="https://images.unsplash.com/photo-1611892440504-42a792e24d32?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                                    alt="Double Room">
                                <div class="price-badge">$8,500 / night</div>
                                <div class="overlay d-flex align-items-center justify-content-center"
                                    style="position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.3); opacity:0; transition:0.3s;">
                                    <span class="btn btn-light rounded-pill"><i class="bi bi-eye"></i> View
                                        Details</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h3 class="card-title h4">Double Room</h3>
                                <div class="mb-3 text-warning">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-half"></i>
                                </div>
                                <p class="card-text text-muted flex-grow-1">Ideal for couples or friends. Spacious room
                                    with a king-size bed...</p>
                                <ul
                                    class="list-unstyled text-secondary mb-4 list-group list-group-flush list-group-horizontal-sm flex-wrap">
                                    <li class="me-3 mb-2"><i class="bi bi-wifi me-1"></i> Free Wifi</li>
                                    <li class="me-3 mb-2"><i class="bi bi-water me-1"></i> Ocean View</li>
                                    <li class="me-3 mb-2"><i class="bi bi-cup-hot me-1"></i> Breakfast</li>
                                </ul>
                                <a href="booking.jsp?room_type=Double"
                                    class="btn btn-primary w-100 mt-auto shadow-sm">Book This Room</a>
                            </div>
                        </div>
                    </div>

                    <!-- Luxury Suite -->
                    <div class="col-lg-4 col-md-6">
                        <div class="card room-card h-100" data-room-type="Luxury" data-price="15,000"
                            data-description="The ultimate experience. Expansive suite with separate living area, jacuzzi, and premium concierge service. Enjoy panoramic views and exclusive access to the VIP lounge."
                            data-capacity="4" data-check-in="13:00" data-check-out="12:00"
                            data-image-url="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                            data-images="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80,https://images.unsplash.com/photo-1591088398332-8a7791972843?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80,https://images.unsplash.com/photo-1578683010236-d716f9a3f461?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80">

                            <div class="room-img-wrapper" style="cursor: pointer;">
                                <img src="https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80"
                                    alt="Luxury Suite">
                                <div class="price-badge">$15,000 / night</div>
                                <div class="overlay d-flex align-items-center justify-content-center"
                                    style="position:absolute; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.3); opacity:0; transition:0.3s;">
                                    <span class="btn btn-light rounded-pill"><i class="bi bi-eye"></i> View
                                        Details</span>
                                </div>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h3 class="card-title h4">Luxury Suite</h3>
                                <div class="mb-3 text-warning">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                </div>
                                <p class="card-text text-muted flex-grow-1">The ultimate experience. Expansive suite
                                    with separate living area...</p>
                                <ul
                                    class="list-unstyled text-secondary mb-4 list-group list-group-flush list-group-horizontal-sm flex-wrap">
                                    <li class="me-3 mb-2"><i class="bi bi-check-circle-fill text-primary me-1"></i> All
                                        Inclusive</li>
                                    <li class="me-3 mb-2"><i class="bi bi-droplet-fill me-1"></i> Jacuzzi</li>
                                    <li class="me-3 mb-2"><i class="bi bi-person-fill me-1"></i> Butler</li>
                                </ul>
                                <a href="booking.jsp?room_type=Luxury"
                                    class="btn btn-outline-primary w-100 mt-auto">Book Now</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer" id="contact">
            <div class="container">
                <div class="row g-4">
                    <div class="col-lg-4 mb-4 mb-lg-0">
                        <h5 class="text-uppercase mb-4 fw-bold spacing-1"><i class="bi bi-water me-2"></i>Ocean View
                            Resort</h5>
                        <p>Experience the pinnacle of luxury and relaxation. Our resort offers an unforgettable escape
                            with world-class amenities and breathtaking views.</p>
                        <div class="mt-4">
                            <a href="#" class="btn btn-outline-light btn-sm rounded-circle me-2"><i
                                    class="bi bi-facebook"></i></a>
                            <a href="#" class="btn btn-outline-light btn-sm rounded-circle me-2"><i
                                    class="bi bi-twitter"></i></a>
                            <a href="#" class="btn btn-outline-light btn-sm rounded-circle me-2"><i
                                    class="bi bi-instagram"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-4 mb-4 mb-lg-0">
                        <h5 class="text-uppercase mb-4 fw-bold">Contact Info</h5>
                        <ul class="list-unstyled">
                            <li class="mb-3"><i class="bi bi-geo-alt me-2 text-primary"></i> 123 Paradise Road, Tropical
                                Island, 5000</li>
                            <li class="mb-3"><a href="tel:+1234567890"><i class="bi bi-telephone me-2 text-primary"></i>
                                    +1 (234) 567-890</a></li>
                            <li class="mb-3"><a href="mailto:info@oceanview.com"><i
                                        class="bi bi-envelope me-2 text-primary"></i> info@oceanview.com</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-4">
                        <h5 class="text-uppercase mb-4 fw-bold">Newsletter</h5>
                        <p>Subscribe to receive special offers and updates.</p>
                        <div class="input-group mb-3">
                            <input type="text" class="form-control bg-dark border-secondary text-light"
                                placeholder="Your Email" aria-label="Recipient's username">
                            <button class="btn btn-primary" type="button">Subscribe</button>
                        </div>
                    </div>
                </div>
                <hr class="my-4 border-secondary">
                <div class="text-center">
                    <p class="mb-0 text-muted">&copy; 2024 Ocean View Resort. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <!-- Room Details Modal -->
        <div class="modal fade" id="roomDetailsModal" tabindex="-1" aria-labelledby="roomModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header border-0">
                        <h5 class="modal-title display-6" id="roomModalLabel">Room Details</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-0">
                        <!-- Modal Hero Image Carousel -->
                        <div id="roomCarousel" class="carousel slide" data-bs-ride="carousel">
                            <div class="carousel-indicators" id="carouselIndicators">
                                <!-- Indicators injected via JS -->
                            </div>
                            <div class="carousel-inner" id="carouselInner" style="height: 400px;">
                                <!-- Images injected via JS -->
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#roomCarousel"
                                data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#roomCarousel"
                                data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </div>

                        <div class="p-4 p-lg-5" id="roomModalBodyContent">
                            <!-- Content injected via JS -->
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <a href="#" id="modalBookBtn" class="btn btn-primary px-5">Book This Room</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS for Modal -->
        <script src="js/home.js"></script>
    </body>

    </html>