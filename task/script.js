
const month = document.getElementById("monthly");
const yearly = document.getElementById("yearly");
const toggleMonth = document.getElementById("toggleMonthly");
const toggleYearly = document.getElementById("toggleYearly");

function toggleButton(event) {
    // Get the clicked button element
    const clickedButton = event.target;

    // Toggle the 'color-toggle' class on the clicked button
    clickedButton.classList.toggle('color-toggle');

    if (clickedButton === toggleMonth) {
        //for changing the cards
        month.classList.remove("d-none");
        yearly.classList.add("d-none");
        toggleMonth.classList.add("active");
        toggleYearly.classList.remove("active");
        //for color
        toggleYearly.classList.remove('color-toggle');
    } else {
        //for changing the cards
        yearly.classList.remove("d-none");
        month.classList.add("d-none");
        toggleYearly.classList.add("active");
        toggleMonth.classList.remove("active");
        //for color
        toggleMonth.classList.remove('color-toggle');
    }
}

// Add event listeners to both buttons
toggleMonth.addEventListener('click', toggleButton);
toggleYearly.addEventListener('click', toggleButton);
