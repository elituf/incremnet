function update() {
    const key = document.getElementById('key').value || 'changeme';
    const code = `<iframe src="https://increm.net/badge?key=${key}" title="incremnet badge" width="88" height="31" style="border: none; background: url('https://increm.net/bg.png');"></iframe>`;
    document.getElementById('code').value = code;
}

function copy() {
    document.querySelector('textarea').select();
    document.execCommand('copy');
    let btn = document.querySelector('.copy-btn');
    btn.textContent = 'ok !';
    setTimeout(function () {
        btn.textContent = 'copy';
    }, 1000)
}
