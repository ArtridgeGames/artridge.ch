(() => {

  const rawData = localStorage.getItem('artridge_blockrush');
  if (!rawData) return;
  const data = JSON.parse(rawData);
  if (!data) return;

  for (const [index, value] of data.entries()) {
    if (index === 0) continue;
    if (!value) continue;
    pico8_gpio[index] = value;
  }

})();

window.setInterval(() => {

  if (pico8_gpio[127]) {
    
    try {
      if (pico8_gpio[127] === 255) {
        parent.cmgGameEvent('start');
      } else {
        parent.cmgGameEvent('start', pico8_gpio[127]);
      }
    } catch (e) {
      console.warn('cmgGameEvent not available');
    }

    pico8_gpio[127] = undefined;
  }

  localStorage.setItem('artridge_blockrush', JSON.stringify(pico8_gpio));
}, 1);


function isLandscape() {
  return window.innerWidth > window.innerHeight;
}

function isDevMobile() {
  let isIOS = (/iPad|iPhone|iPod/.test(navigator.platform) ||
  (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1)) &&
  !window.MSStream
  return navigator.userAgent.match(/Android/i)
  || navigator.userAgent.match(/webOS/i)
  || navigator.userAgent.match(/iPhone/i)
  || navigator.userAgent.match(/iPad/i)
  || navigator.userAgent.match(/iPod/i)
  || navigator.userAgent.match(/BlackBerry/i)
  || navigator.userAgent.match(/Windows Phone/i)
  || isIOS
}

((context) => {
  if (context.state !== "suspended") return;
  const b = document.body;
  const events = ["touchstart", "touchend", "mousedown", "keydown", "click"];
  events.forEach(e => b.addEventListener(e, unlock, false));
  function unlock() {
    context.resume().then(clean);
  }
  function clean() {events.forEach(e => b.removeEventListener(e, unlock));}
})(window.AudioContext());

var canvasContainer = document.getElementById("canvas");
var rect = canvasContainer.getBoundingClientRect();
var distance = rect.right / (isLandscape() && 4.85 || 2.2);

function getPageTopLeft(el) {
  var rect = el.getBoundingClientRect();
  var docEl = document.documentElement;
  return {
    left: rect.left + (window.pageXOffset || docEl.scrollLeft || 0),
    top: rect.top + (window.pageYOffset || docEl.scrollTop || 0)
  };
}

function updateBtns() {
  var canvasContainer = document.getElementById("canvas");
  var rect = canvasContainer.getBoundingClientRect();
  distance = rect.right / (isLandscape() && 4.85 || 2.2);

  if (isLandscape() && navigator.userAgent.match(/iPhone/i)) {
    distance = rect.right / 3.6;
  }

  var gamepad = document.getElementById("gamepad");
  var btnO = document.getElementById("btn-o");
  var btnX = document.getElementById("btn-x");
  var btnP = document.getElementById("btn-p");
  var btnS = document.getElementById("switch");
  var touchBtns = document.getElementById("touch-buttons")
  
  document.documentElement.style.setProperty("--move-indicator-size", (distance / 18) + "px")
  
  touchBtns.style.width = `${distance}px`;
  touchBtns.style.height = `${distance}px`;
  
  btnO.style.width = "50%";
  btnO.style.height = "50%";
  btnX.style.width = "50%";
  btnX.style.height = "50%";
  btnP.style.width = "50%";
  btnP.style.height = "50%";
  btnS.style.width = "50%";
  btnS.style.height = "50%";
  gamepad.style.width = `${distance}px`;
  gamepad.style.height = `${distance}px`;

  if (!isLandscape()) {
    document.documentElement.style.setProperty('--text-size', '40px');
  } else {
    document.documentElement.style.setProperty('--text-size', '20px');
  }
  
  // ----------------- DISPLAY TOUCH CONTROLS? ----------------- %>
  if(isDevMobile()) {
    document.body.className = " touch-supported";
    window.TOUCH = true;
    var size = isLandscape() ? "150px" : "27.7px";
    var offset = isLandscape() ? "30px" : "11px";
    if (isLandscape() && navigator.userAgent.match(/iPhone/i)) {
      size = "85px";
      offset = "30px";
    }
    document.documentElement.style.setProperty("--pico-display", "block")
    document.documentElement.style.setProperty("--canvas-size", size);
    document.documentElement.style.setProperty("--canvas-border", "0px");
    document.documentElement.style.setProperty("--canvas-offset", offset);
    var isMobile = true;
  } else {
    document.body.className = "touch-not-supported";
    document.body.style.overflowY = document.fullscreenElement ? "hidden" : "scroll";
    document.documentElement.style.setProperty('--canvas-size', '0px');
    document.documentElement.style.setProperty('--canvas-border', '0px');
    document.getElementById("canvas").style.border = "none";
    document.documentElement.style.setProperty('--canvas-offset', '0px');
    var isMobile = false;
  }

  if (isMobile) {
    var element = document.getElementById('canvas');
    var positionInfo = element.getBoundingClientRect();
    var width = positionInfo.width;
    var border = width / 128;
    if (navigator.userAgent.match(/iPad/i)) {
      document.documentElement.style.setProperty('--border-size', border * 0.9 + "px");
    } else {
      document.documentElement.style.setProperty('--border-size', border * 0.9 + "px");
    }
  } else {
    document.documentElement.style.setProperty('--border-size', "0px");
  }
}

window.addEventListener('orientationchange', () => {
  window.setTimeout(updateBtns, 100);
});
window.addEventListener('loadstart', updateBtns);
updateBtns();

window.addEventListener("resize", () => {
  window.setTimeout(updateBtns, 100);
}, false);
var pico8_buttons = [0, 0, 0, 0, 0, 0, 0, 0];
var btnO = document.getElementById("btn-o");
var btnS = document.getElementById("switch");
btnS.style.backgroundImage = "url(images/switch.png)"
btnO.style.backgroundImage = "url(images/oButton.png)"
  btnO.addEventListener("touchstart", (e)=>{
    e.preventDefault()
    startedGame = true;
    if (isPaused) {
      pico8_buttons[0] = 8
    } else {
      pico8_buttons[0] = 16
    }
    setTimeout(()=>{
      pico8_buttons[0] = 0
    },100)
  })

var btnX = document.getElementById("btn-x");
btnX.style.backgroundImage = "url(images/xButton.png)"
btnX.addEventListener("touchstart", (e)=>{
  e.preventDefault()
  startedGame = true;
  if (!isPaused) {
    pico8_buttons[0] = 32
    setTimeout(()=>{
      pico8_buttons[0] = 0
    },100)
  } else {
    Module.pico8ToggleSound();
    isMuted = !isMuted;
    btnX.style.backgroundImage = isMuted && "url(images/soundOff.png)" || "url(images/soundOn.png)"
  }
})
var isMuted = false;
var isPaused = false;
var btnP = document.getElementById("btn-p");
btnP.style.backgroundImage = "url(images/pause.png)"
btnP.addEventListener("touchstart", (e)=>{
  e.preventDefault()
  if (pico8_gpio[0] === 1) {
    pico8_buttons[0] = 64
    setTimeout(()=>{
        pico8_buttons[0] = 0
    },100);
    startedGame = true;
    isPaused = !isPaused;
    if (isPaused) {
      btnX.style.backgroundImage = isMuted && "url(images/soundOff.png)" || "url(images/soundOn.png)"
      btnO.style.backgroundImage = "url(images/down.png)"
      btnS.style.backgroundImage = "url(images/up.png)"
      btnP.style.backgroundImage = "url(images/play.png)"
    } else {
      btnX.style.backgroundImage = "url(images/xButton.png)"
      btnO.style.backgroundImage = "url(images/oButton.png)"
      btnS.style.backgroundImage = "url(images/switch.png)"
      btnP.style.backgroundImage = "url(images/pause.png)"
    }
  }
})

document.getElementById("switch").addEventListener("touchstart", switchInput);

var gamepad = document.getElementById("gamepad");
var buttons = document.getElementById("touch-buttons");
var trackIsRight = true
function switchInput(e) {
  e.preventDefault();
  if (isPaused) {
    pico8_buttons[0] = 4
    setTimeout(()=>{
      pico8_buttons[0] = 0
    },100)
  } else {
    trackIsRight = !trackIsRight;
    if (trackIsRight) {
      buttons.style.left = "11px"
      gamepad.style.right = "11px"
      buttons.style.right = "unset"
      gamepad.style.left = "unset"
    } else {
      gamepad.style.left = "11px"
      buttons.style.right = "11px"
      gamepad.style.right = "unset"
      buttons.style.left = "unset"
    }
  }
}

/* KEY = { L: 1, R: 2, U: 4, D: 8, O: 16, X: 32, P: 64 }, */

var picoButtons = document.getElementsByClassName("pico-btn");
for (const btn of picoButtons) {
  btn.addEventListener('touchstart', e => {
    e.preventDefault();
    let t = '';
    let c = btn.classList.toString();
    if (c.includes('up') || c.includes('down')) t = 'translateX(-50%)';
    if (c.includes('left') || c.includes('right')) t = 'translateY(-50%)';
    btn.style.transform = `scale(0.9) ${t}`;
    setTimeout(()=>{
      btn.style.transform = `scale(1) ${t}`;
    },150);

    if (btn.parentNode.classList.toString().includes('gamepad')) {
      const KEYS = { left: 1, right: 2, up: 4, down: 8, O: 16, X: 32 };
      pico8_buttons[0] = KEYS[btn.classList.toString().replace('pico-btn','').trim()];
      setTimeout(()=>{
        pico8_buttons[0] = 0
      },100);
    }
  });
}

(() => {
  const domains = [
    'https://www.coolmathgames.com',
    'coolmathgames.com',
    'www.coolmathgames.com',
    'edit.coolmathgames.com',
    'www.stage.coolmathgames.com',
    'edit-stage.coolmathgames.com',
    'dev.coolmathgames.com',
    'm.coolmathgames.com',
    'https://www.coolmath-games.com',
    'www.coolmath-games.com',
    'edit.coolmath-games.com',
    'edit-stage.coolmath-games.com',
    'dev.coolmath-games.com',
    'm.coolmath-games.com',
    'd8-edit.coolmathgames.com'
  ];

  let shouldRedirect = true;
  for (const domain of domains) {
    if (location.host.includes(domain)) shouldRedirect = false;
  }
  if (shouldRedirect) {
    window.location.href = 'https://www.coolmathgames.com';
  }
})();