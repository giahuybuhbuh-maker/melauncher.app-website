// Crafting grid: 9 "nguyen lieu" tuong trung cho cong nghe dung trong launcher
  const ingredients = [
    {label:'Java', svg:'<path d="M8 21c4 1.5 8 1.5 12 0" stroke-linecap="round"/><path d="M9 3c-2 3 3 4 1 8" stroke-linecap="round"/><path d="M13 3c-2 3 3 4 1 8" stroke-linecap="round"/>'},
    {label:'JavaFX', svg:'<rect x="3" y="4" width="18" height="14" rx="1"/><path d="M3 8h18" stroke-linecap="round"/>'},
    {label:'Gradle', svg:'<circle cx="12" cy="12" r="8"/><path d="M12 4v2M12 18v2M4 12h2M18 12h2" stroke-linecap="round"/>'},
    {label:'MS Auth', svg:'<rect x="3" y="3" width="8" height="8"/><rect x="13" y="3" width="8" height="8"/><rect x="3" y="13" width="8" height="8"/><rect x="13" y="13" width="8" height="8"/>'},
    {label:'Fabric', svg:'<path d="M4 4l16 16M20 4L4 20" stroke-linecap="round"/>'},
    {label:'Gson', svg:'<path d="M8 4c-3 1-3 6 0 8-3 2-3 7 0 8" stroke-linecap="round"/><path d="M16 4c3 1 3 6 0 8 3 2 3 7 0 8" stroke-linecap="round"/>'},
    {label:'Mojang API', svg:'<circle cx="12" cy="12" r="8"/><path d="M4 12h16M12 4c3 3 3 13 0 16M12 4c-3 3-3 13 0 16" stroke-linecap="round"/>'},
    {label:'GC Tuning', svg:'<path d="M13 2L4 14h6l-1 8 9-12h-6z"/>'},
    {label:'Config', svg:'<rect x="4" y="6" width="16" height="12" rx="1"/><path d="M8 6V4M16 6V4" stroke-linecap="round"/>'}
  ];

  const grid = document.getElementById('craftGrid');
  ingredients.forEach((ing, i) => {
    const slot = document.createElement('div');
    slot.className = 'slot';
    slot.innerHTML = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">${ing.svg}</svg><span class="tip">${ing.label}</span>`;
    grid.appendChild(slot);
  });

  function playCraftAnimation(){
    document.querySelectorAll('.slot').forEach((s, i) => {
      setTimeout(() => s.classList.add('show'), i * 70);
    });
    setTimeout(() => document.getElementById('craftOutput').classList.add('show'), ingredients.length * 70 + 200);
  }

  const craftSection = document.getElementById('craftSection');
  const craftObserver = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (e.isIntersecting) { playCraftAnimation(); craftObserver.disconnect(); }
    });
  }, { threshold: 0.4 });
  craftObserver.observe(craftSection);

  // Reveal on scroll cho cac khoi con lai
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('in'); });
  }, { threshold: 0.2 });
  document.querySelectorAll('[data-reveal]').forEach(el => revealObserver.observe(el));

  // Placeholder download button - nhac nguoi dung thay link that
  document.getElementById('downloadBtn').addEventListener('click', (e) => {
    e.preventDefault();
    alert('Thay link tai that vao href cua nut nay (vd: link GitHub Releases) trong file index.html.');
  });
