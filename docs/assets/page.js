const root = document.documentElement;
try {
  const saved = localStorage.getItem("moonpug-theme");
  if (saved) root.dataset.theme = saved;
} catch {}
document.querySelector("#theme")?.addEventListener("click", () => {
  const dark = root.dataset.theme
    ? root.dataset.theme === "dark"
    : matchMedia("(prefers-color-scheme: dark)").matches;
  root.dataset.theme = dark ? "light" : "dark";
  try { localStorage.setItem("moonpug-theme", root.dataset.theme); } catch {}
});
const links = [...document.querySelectorAll("aside a[href^='#']")];
const seen = new IntersectionObserver((entries) => {
  for (const e of entries) {
    if (!e.isIntersecting) continue;
    for (const a of links) a.classList.toggle("on", a.getAttribute("href") === `#${e.target.id}`);
  }
}, { rootMargin: "-30% 0px -60% 0px" });
for (const a of links) {
  const target = document.getElementById(a.getAttribute("href").slice(1));
  if (target) seen.observe(target);
}
