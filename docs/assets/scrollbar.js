// The page scroll bar is hidden while the page stands at its top, the way a
// sheet shows no edge until it is lifted, and appears from the first scroll
// on. Its width is kept either way, so the page does not shift sideways.
const root = document.documentElement;
const mark = () => root.classList.toggle("at-top", scrollY === 0);
addEventListener("scroll", mark, { passive: true });
mark();
