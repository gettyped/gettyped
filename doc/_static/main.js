document.addEventListener('DOMContentLoaded', function() {
    let toc = document.getElementById('table-of-contents');
    let tocH = toc.querySelector('h2');
    tocH.addEventListener('click', function() {
        toc.classList.toggle('show');
    });
});
