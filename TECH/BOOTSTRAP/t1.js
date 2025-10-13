// $(document).ready(function() {
 
//   $("#owl-demo").owlCarousel({
//     navigation : true,
//     items : 3, 
//     loop:true,
//        nav:true,
//     animateOut: 'fadeOut',
//        animateIn: 'fadeIn',
//   });
 
// });



document.addEventListener("DOMContentLoaded", function () {
  const owlDemo = document.querySelector("#owl-demo");

  if (owlDemo) {
    const owl = new OwlCarousel(owlDemo, {
      items: 3,
      loop: true,
      nav: true,
      animateOut: 'fadeOut',
      animateIn: 'fadeIn',
    });

    // Enable navigation buttons
    if (owl.options.nav) {
      owlDemo.querySelectorAll(".owl-nav").forEach(nav => {
        nav.style.display = "block";
      });
    }
  }
});
