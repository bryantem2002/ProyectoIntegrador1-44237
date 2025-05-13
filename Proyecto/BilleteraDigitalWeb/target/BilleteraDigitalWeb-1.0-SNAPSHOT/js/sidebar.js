/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/ClientSide/javascript.js to edit this template
 */


  // Toggle sidebar on mobile
  function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const menuOpen = document.getElementById('menuOpen');
    const menuClose = document.getElementById('menuClose');
    
    sidebar.classList.toggle('-translate-x-full');
    menuOpen.classList.toggle('hidden');
    menuOpen.classList.toggle('block');
    menuClose.classList.toggle('hidden');
    menuClose.classList.toggle('block');
  }
  
  // Toggle section menus
  function toggleSection(id) {
    const section = document.getElementById(id);
    section.classList.toggle('hidden');
    
    // Rotate the icon when opened/closed
    const iconId = id.replace('Menu', 'Icon');
    const icon = document.getElementById(iconId);
    if (icon) {
      icon.classList.toggle('rotate-180');
    }
  }
  
  // Initialize mobile view
  function initMobileView() {
    if (window.innerWidth < 1024) {
      document.getElementById('sidebar').classList.add('-translate-x-full');
    }
  }
  
  // Call on page load
  initMobileView();
  
  // Update on window resize
  window.addEventListener('resize', initMobileView);
