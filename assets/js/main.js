// ===== LOGIN MODAL (요소가 있을 때만) =====
const loginBtn = document.getElementById("loginBtn");
const modal = document.getElementById("loginModal");
const closeModal = document.getElementById("closeModal");

if (loginBtn && modal) {
  loginBtn.addEventListener("click", () => modal.classList.remove("hidden"));
}
if (closeModal && modal) {
  closeModal.addEventListener("click", () => modal.classList.add("hidden"));
}

// ===== CAROUSEL =====
const track = document.getElementById("carouselTrack");
const indicatorsEl = document.getElementById("indicators");
const toggleBtn = document.getElementById("togglePlay");

let timer = null;
let autoplay = true;
let interval = 4000;

let cards = [];
let index = 0;
let visibleCount = getVisibleCount();

fetch("assets/js/data/carousel.json")
  .then(res => res.json())
  .then(data => initCarousel(data));

function getVisibleCount() {
  return window.innerWidth < 768 ? 1 : 3;
}

function initCarousel(data) {
  autoplay = data.autoplay;
  interval = data.interval;

  const originals = data.cards;
  const count = originals.length;
  visibleCount = getVisibleCount();

  // 앞/뒤 클론 생성
  const head = originals.slice(-visibleCount);
  const tail = originals.slice(0, visibleCount);
  cards = [...head, ...originals, ...tail];

  cards.forEach(card => {
    const el = document.createElement("div");
    el.className = "carousel-card";
    el.innerHTML = `
      <div class="card-text">
        <h3>${card.title}</h3>
        <p>${card.description}</p>
      </div>
      <img src="${card.image}">
    `;
    el.onclick = () => location.href = card.link;
    track.appendChild(el);
  });

  // 인디케이터는 실제 카드만
  originals.forEach((_, i) => {
    const dot = document.createElement("span");
    dot.onclick = () => moveTo(i);
    indicatorsEl.appendChild(dot);
  });

  index = visibleCount;
  updatePosition(false);
  updateIndicators();

  track.addEventListener("transitionend", () => {
    if (index >= count + visibleCount) {
      index = visibleCount;
      updatePosition(false);
    }
    if (index < visibleCount) {
      index = count + visibleCount - 1;
      updatePosition(false);
    }
  });

  if (autoplay) start();
}

function moveTo(i) {
  index = i + visibleCount;
  updatePosition(true);
  updateIndicators();
}

function updatePosition(animate) {
  const cardWidth = 100 / visibleCount;
  track.style.transition = animate ? "transform 0.6s ease" : "none";
  track.style.transform = `translateX(-${index * cardWidth}%)`;
}

function updateIndicators() {
  const realIndex =
    (index - visibleCount) %
    indicatorsEl.children.length;

  [...indicatorsEl.children].forEach((d, i) =>
    d.classList.toggle("active", i === realIndex)
  );
}

function start() {
  timer = setInterval(() => {
    index++;
    updatePosition(true);
    updateIndicators();
  }, interval);
}

function stop() {
  clearInterval(timer);
  timer = null;
}

toggleBtn.onclick = () => {
  if (timer) {
    stop();
    toggleBtn.textContent = "▶";
  } else {
    start();
    toggleBtn.textContent = "❚❚";
  }
};

window.addEventListener("resize", () => location.reload());



function escapeHtml(str) {
  return String(str)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}
