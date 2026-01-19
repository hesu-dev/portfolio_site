// LOGIN MODAL
const loginBtn = document.getElementById("loginBtn");
const modal = document.getElementById("loginModal");
const closeModal = document.getElementById("closeModal");

loginBtn.onclick = () => modal.classList.remove("hidden");
closeModal.onclick = () => modal.classList.add("hidden");

// CAROUSEL
let index = 0;
const slides = document.querySelector(".slides");
const total = document.querySelectorAll(".slide").length;

document.getElementById("next").onclick = () => move(1);
document.getElementById("prev").onclick = () => move(-1);

function move(dir) {
  index = (index + dir + total) % total;
  slides.style.transform = `translateX(-${index * 100}%)`;
}

// CLICK SLIDE
document.querySelectorAll(".slide").forEach(slide => {
  slide.onclick = () => {
    location.href = slide.dataset.link;
  };
});
