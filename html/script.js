window.addEventListener('load', () => {
    const currentImg = localStorage.getItem('profile');
    (currentImg != null) ? document.getElementById('profile').src = currentImg : false;

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
    document.getElementById('report').addEventListener('click', _ => document.querySelector('.report').style.display = 'flex', false);
    document.getElementById('settings').addEventListener('click', _ => document.querySelector('.img-inp').style.display = 'flex', false);

    document.getElementById('report-cancel').addEventListener('click', _ => {
        document.querySelector('.report').style.display = 'none';
        document.getElementById('title-inp').value = '';
        document.getElementById('desc-inp').value = '';
    }, false)
    document.getElementById('report-accept').addEventListener('click', _ => {
        let title = document.getElementById('title-inp').value;
        let desc = document.getElementById('desc-inp').value;
        if (title && desc) {
            fetchNUI('sendReport', {title: title, desc: desc});
            document.querySelector('.report').style.display = 'none';
            document.getElementById('title-inp').value = '';
            document.getElementById('desc-inp').value = '';
        }
    }, false)
    document.getElementById('avatar-cancel').addEventListener('click', _ => {
        document.querySelector('.img-inp').style.display = 'none';
        document.getElementById('avatar-inp').value = '';
    }, false)
    document.getElementById('avatar-accept').addEventListener('click', _ => {
        let val = document.getElementById('avatar-inp').value;
        if (val.checkUrl()) {
            document.getElementById('profile').src = val;
            localStorage.setItem('profile', val)
            document.querySelector('.img-inp').style.display = 'none'
            document.getElementById('avatar-inp').value = '';
        }
    }, false)

    document.addEventListener('keyup', e => {
        if (e.key == 'Escape') {
            fetchNUI('close');
            document.querySelector('.settings-container').style.display = 'none';
        }
    })
});

String.prototype.checkUrl = function() {
    return (this.match(/\.(jpeg|jpg|gif|png)$/) != null)
}

const fetchNUI = async (cbname, data) => {
    const options = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(data)
    };
    const resp = await fetch(`https://ev-infopanel/${cbname}`, options);
    return await resp.json();
}

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
    if (data) {
        document.getElementById('main-name').textContent = data.player;
        document.getElementById('main-identifier').textContent = data.identifier
        document.getElementById('set-name').textContent = data.name;
        document.getElementById('set-job').textContent = data.job;
        document.getElementById('set-height').textContent = data.height;
        document.getElementById('set-cash').textContent = data.cash;
        document.getElementById('set-bank').textContent = data.bank;
        document.getElementById('set-dob').textContent = data.dob;
        document.getElementById('set-phone').textContent = data.phone_number;
        document.getElementById('set-connections').textContent = data.connections;
        document.getElementById('set-gametime').textContent = data.game_time;
    }
}