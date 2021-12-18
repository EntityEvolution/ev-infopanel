window.addEventListener('load', () => {
    window.addEventListener('message', e => {
        if (e.data.data) {
            if (window.getComputedStyle(document.querySelector('.settings-container')).getPropertyValue('display') != 'flex') {
                document.querySelector('.settings-container').style.display = 'flex';
            }
            updateData(e.data.data)
        } else {
            if (window.getComputedStyle(document.querySelector('.settings-container')).getPropertyValue('display') == 'flex') {
                document.querySelector('.settings-container').style.display = 'none';
            }
        }
    })

    document.getElementById('stats').addEventListener('click', changeDisplay, false);
    document.getElementById('back').addEventListener('click', changeDisplay, false);
    document.getElementById('settings').addEventListener('click', a, false);
});

const changeDisplay = () => {
    const elems = document.getElementsByClassName('change');
    for (let i = 0; i < elems.length; i++) {
        if (window.getComputedStyle(elems[i]).getPropertyValue('display') == 'flex') {
            (i == 0) ? (document.getElementById('settings').style.display = 'none', document.getElementById('back').style.display = 'block') : (document.getElementById('settings').style.display = 'block', document.getElementById('back').style.display = 'none');
            elems[i].style.display = 'none';
        } else {
            elems[i].style.display = 'flex';
        }
    }
}

const updateData = data => {

}