(function ($) {
    "use strict";

    // Spinner
    var spinner = function () {
        setTimeout(function () {
            if ($('#spinner').length > 0) {
                $('#spinner').removeClass('show');
            }
        }, 1);
    };
    spinner();

    // Fixed Navbar
    $(window).scroll(function () {
        if ($(window).width() < 992) {
            if ($(this).scrollTop() > 55) {
                $('.fixed-top').addClass('shadow');
            } else {
                $('.fixed-top').removeClass('shadow');
            }
        } else {
            if ($(this).scrollTop() > 55) {
                $('.fixed-top').addClass('shadow').css('top', 0);
            } else {
                $('.fixed-top').removeClass('shadow').css('top', 0);
            }
        }
    });

    // Back to top button
    $(window).scroll(function () {
        if ($(this).scrollTop() > 300) {
            $('.back-to-top').fadeIn('slow');
        } else {
            $('.back-to-top').fadeOut('slow');
        }
    });
    $('.back-to-top').click(function () {
        $('html, body').animate({ scrollTop: 0 }, 1500, 'easeInOutExpo');
        return false;
    });

    // Testimonial carousel
    $(".testimonial-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 2000,
        center: false,
        dots: true,
        loop: true,
        margin: 25,
        nav: true,
        navText: [
            '<i class="bi bi-arrow-left"></i>',
            '<i class="bi bi-arrow-right"></i>'
        ],
        responsiveClass: true,
        responsive: {
            0: { items: 1 },
            576: { items: 1 },
            768: { items: 1 },
            992: { items: 2 },
            1200: { items: 2 }
        }
    });

    // Vegetable carousel
    $(".vegetable-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 1500,
        center: false,
        dots: true,
        loop: true,
        margin: 25,
        nav: true,
        navText: [
            '<i class="bi bi-arrow-left"></i>',
            '<i class="bi bi-arrow-right"></i>'
        ],
        responsiveClass: true,
        responsive: {
            0: { items: 1 },
            576: { items: 1 },
            768: { items: 2 },
            992: { items: 3 },
            1200: { items: 4 }
        }
    });

    // Modal Video
    $(document).ready(function () {
        var $videoSrc;
        $('.btn-play').click(function () {
            $videoSrc = $(this).data("src");
        });

        $('#videoModal').on('shown.bs.modal', function () {
            $("#video").attr('src', $videoSrc + "?autoplay=1&amp;modestbranding=1&amp;showinfo=0");
        });

        $('#videoModal').on('hide.bs.modal', function () {
            $("#video").attr('src', $videoSrc);
        });

        // Add active class to header links
        const navElement = $("#navbarCollapse");
        const currentUrl = window.location.pathname;
        navElement.find('a.nav-link').each(function () {
            const link = $(this);
            const href = link.attr('href');
            if (href === currentUrl) {
                link.addClass('active');
            } else {
                link.removeClass('active');
            }
        });
    });

    // Product Quantity
    $('.quantity button').on('click', function () {
        let change = 0;
        var button = $(this);
        var input = button.closest('.quantity').find('input');
        var oldValue = parseInt(input.val()) || 1;

        if (button.hasClass('btn-plus')) {
            var newVal = oldValue + 1;
            change = 1;
        } else {
            if (oldValue > 1) {
                var newVal = oldValue - 1;
                change = -1;
            } else {
                newVal = 1;
            }
        }

        input.val(newVal);

        // Update hidden input
        const index = input.attr("data-cart-detail-index");
        const hiddenInput = document.getElementById(`cartDetails${index}.quantity`);
        if (hiddenInput) {
            hiddenInput.value = newVal;
        }

        // Update price
        const price = parseFloat(input.attr("data-cart-detail-price")) || 0;
        const id = input.attr("data-cart-detail-id");
        const priceElement = $(`p[data-cart-detail-id='${id}']`);
        if (priceElement.length) {
            const newPrice = price * newVal;
            priceElement.text(formatCurrency(newPrice.toFixed(2)) + " đ");
        }

        // Update total price
        debounceUpdateTotal(() => {
            const totalPriceElement = $(`p[data-cart-total-price]`);
            if (totalPriceElement.length) {
                let currentTotal = parseFloat(totalPriceElement.attr("data-cart-total-price")) || 0;
                let newTotal = currentTotal + change * price;
                totalPriceElement.text(formatCurrency(newTotal.toFixed(2)) + " đ");
                totalPriceElement.attr("data-cart-total-price", newTotal);
            }
        }, 300);
    });

    // Debounce function for updating total
    let updateTotalTimeout;
    function debounceUpdateTotal(callback, delay) {
        clearTimeout(updateTotalTimeout);
        updateTotalTimeout = setTimeout(callback, delay);
    }

    // Format currency
    function formatCurrency(value) {
        const formatter = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND',
            minimumFractionDigits: 0
        });
        return formatter.format(value);
    }
      //handle filter products
        $('#btnFilter').click(function (event) {
            event.preventDefault();

            let factoryArr = [];
            let targetArr = [];
            let priceArr = [];
            //factory filter
            $("#factoryFilter .form-check-input:checked").each(function () {
                factoryArr.push($(this).val());
            });

            //target filter
            $("#targetFilter .form-check-input:checked").each(function () {
                targetArr.push($(this).val());
            });

            //price filter
            $("#priceFilter .form-check-input:checked").each(function () {
                priceArr.push($(this).val());
            });

            //sort order
            let sortValue = $('input[name="radio-sort"]:checked').val();

            const currentUrl = new URL(window.location.href);
            const searchParams = currentUrl.searchParams;

            // Add or update query parameters
            searchParams.set('page', '1');
            searchParams.set('sort', sortValue);

            if (factoryArr.length > 0) {
                searchParams.set('factory', factoryArr.join(','));
            }
            if (targetArr.length > 0) {
                searchParams.set('target', targetArr.join(','));
            }
            if (priceArr.length > 0) {
                searchParams.set('price', priceArr.join(','));
            }

            // Update the URL and reload the page
            window.location.href = currentUrl.toString();
        });

        //handle auto checkbox after page loading
        // Parse the URL parameters
        const params = new URLSearchParams(window.location.search);

        // Set checkboxes for 'factory'
        if (params.has('factory')) {
            const factories = params.get('factory').split(',');
            factories.forEach(factory => {
                $(`#factoryFilter .form-check-input[value="${factory}"]`).prop('checked', true);
            });
        }

        // Set checkboxes for 'target'
        if (params.has('target')) {
            const targets = params.get('target').split(',');
            targets.forEach(target => {
                $(`#targetFilter .form-check-input[value="${target}"]`).prop('checked', true);
            });
        }

        // Set checkboxes for 'price'
        if (params.has('price')) {
            const prices = params.get('price').split(',');
            prices.forEach(price => {
                $(`#priceFilter .form-check-input[value="${price}"]`).prop('checked', true);
            });
        }

        // Set radio buttons for 'sort'
        if (params.has('sort')) {
            const sort = params.get('sort');
            $(`input[type="radio"][name="radio-sort"][value="${sort}"]`).prop('checked', true);
        }
})(jQuery);
