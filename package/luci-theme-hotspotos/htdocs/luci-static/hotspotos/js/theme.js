/**
 * HotspotOS Theme JavaScript
 * Minimal, lightweight, no external dependencies
 */

(function() {
    'use strict';

    // Mobile menu toggle
    function initMobileMenu() {
        const nav = document.querySelector('.main-nav');
        if (!nav) return;

        if (!nav.querySelector('.mobile-menu-btn')) {
            const menuBtn = document.createElement('button');
            menuBtn.className = 'mobile-menu-btn';
            menuBtn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>';
            menuBtn.style.cssText = 'display:none;background:none;border:none;color:#6b7280;cursor:pointer;padding:0.5rem;';

            const navMenu = nav.querySelector('.nav-menu');
            if (navMenu) {
                nav.insertBefore(menuBtn, navMenu);
                menuBtn.addEventListener('click', function() {
                    navMenu.classList.toggle('mobile-open');
                });
            }
        }
    }

    // Auto-hide flash messages
    function initFlashMessages() {
        const alerts = document.querySelectorAll('.alert, .cbi-map-descr');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });
    }

    // Add loading state to forms
    function initFormLoading() {
        const forms = document.querySelectorAll('form');
        forms.forEach(function(form) {
            form.addEventListener('submit', function() {
                const submitBtn = form.querySelector('button[type="submit"], input[type="submit"]');
                if (submitBtn) {
                    submitBtn.disabled = true;
                    submitBtn.style.opacity = '0.7';
                    submitBtn.dataset.originalText = submitBtn.value || submitBtn.textContent;
                    if (submitBtn.tagName === 'INPUT') {
                        submitBtn.value = 'Processing...';
                    } else {
                        submitBtn.textContent = 'Processing...';
                    }
                }
            });
        });
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            initMobileMenu();
            initFlashMessages();
            initFormLoading();
        });
    } else {
        initMobileMenu();
        initFlashMessages();
        initFormLoading();
    }

    // Expose theme API
    window.HotspotOSTheme = {
        version: '1.0.0',
        refresh: function() {
            initMobileMenu();
            initFlashMessages();
        }
    };

})();
