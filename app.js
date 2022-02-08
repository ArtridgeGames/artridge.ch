// Vue setup

const app = new Vue({
  el: '#app',
  data: {
    tab: 0,
    tabNames: ["Games", "About", "Account"],
    isSignedIn: false,
    gameSaves: [],
    copyright: '© Artridge 2021 - All Rights Reserved',
    aboutTab: 0,
    removeId: undefined
  },
  watch: {
    tab: function (n) { // saves the current tab name in the window's location's hash
      window.location.hash = this.tabNames[n];
    }
  },
  methods: {
    usr() {
      return firebase.auth().currentUser || {
        updateProfile() {},
        updatePassword() {},
        displayName: '',
        uid: '',
        email: ''
      }
    },
    removeGameSave(id) {
      app.removeId = id;
    },
    cancelSaveRemoval() {
      app.removeId = undefined;
    },
    confirmSaveRemoval() {
      if (app.usr()) {
        firebase.database().ref(`users/${app.usr().uid}/game-data/${app.removeId}`).remove()
          .then(() => {
            for (let i = 0; i<app.gameSaves.length; i++) {
              if (app.gameSaves[i].identifier === app.removeId) app.gameSaves.splice(i, 1);
            }
            app.removeId = undefined;
          })
          .catch(e => {
            console.error(e);
          });
      }
    }
  },
  beforeCreate: function() { // adds ability to press enter to perform login or signup
    let panels = document.querySelectorAll(".auth-method");
    let functions = ["login", "signup"]
    for (let i = 0; i<panels.length; i++) {
      let p = panels[i];
      let inputs = p.querySelectorAll("input");
      for (let j = 0; j<inputs.length; j++) {
        inputs[j].setAttribute("onkeyup", `if (event.key === "Enter") ${functions[i]}(this.parentNode);`);
      }
    }

    (() => {
      let images = document.querySelectorAll("img");
      for (let i = 0; i < images.length; i++) {
        const img = images[i];
        img.setAttribute("draggable", "false");
      }
    })();
  },
  mounted: function() {
    if ('ontouchstart' in document.documentElement) {
      document.addEventListener('touchstart', (e) => {
        e.preventDefault();
      });
    }
  }
});

// Go to correct tab when loading the page
window.onload = () => {
  let n = app.tabNames.indexOf(window.location.hash.replace("#",""));
  if (n !== -1) app.tab = n;
}

firebase.auth().onAuthStateChanged(function(user) {
  window.setTimeout(() => {
    if (user) {
      app.isSignedIn = true;
      app.gameSaves = [];
      firebase.database().ref(`users/${user.uid}/game-data`).once('value', (snap) => {
        let data = snap.val();
        let gameNames = {
          'clicker': 'ClickCorp.',
          'tileswap': 'TileSwap',
          'dodge': 'Dodge',
          'blockrush': 'Block Rush',
          'citybuilder': 'City Builder'
        }
        if (data) {
          let keys = Object.keys(data);
          for (let i = 0; i < keys.length; i++) {
            const game = keys[i];
            app.gameSaves.push({
              title: gameNames[game],
              identifier: game
            });
          }
          let result = [];
          Object.keys(gameNames).forEach(function(key) {
            var found = false;
            app.gameSaves = app.gameSaves.filter(function(item) {
                if(!found && item.identifier === key) {
                    result.push(item);
                    found = true;
                    return false;
                } else 
                    return true;
            });
          });
          app.gameSaves = JSON.parse(JSON.stringify(result));
        }
      });
    } else {
      app.isSignedIn = false;
      app.gameSaves = [];
    }
  },200);
});

// Login function called from HTML
function login(e) {
  let email = e.children[1].value;
  let password = e.children[2].value;
  let error = e.querySelector(".error-message");
  firebase.auth().signInWithEmailAndPassword(email, password).catch(function(e) {
    error.innerHTML = e.message + `<br><button onclick='resetPwd("${email}", this)'>Forgot your password?</button>`;
  });
}

function resetPwd(email, el) {
  firebase.auth().sendPasswordResetEmail(email)
    .then(() => {
      el.parentNode.style.color = "white";
      el.parentNode.innerHTML = `Password reset email sent to ${email}.`;
    })
    .catch((e) => {
      el.parentNode.innerHTML = `The email could not be sent.`;
    });
}

// Signup function called from HTML
function signup(e) {
  let username = e.children[1].value;
  let email = e.children[2].value;
  let password = e.children[3].value;
  let passwordRepeat = e.children[5].value;
  let error = e.querySelector(".error-message");

  if (!username.trim()) {
    error.style.color = "red";
    error.innerHTML = "Invalid username.";
    return;
  }
  if (password !== passwordRepeat) {
    error.style.color = "red";
    error.innerHTML = "Passwords do not match.";
    return;
  }
  firebase.auth().createUserWithEmailAndPassword(email, password).then(() => {
    app.usr().updateProfile({
      displayName: username
    }).then(() => {
      updateDatabaseUser();
    }).catch((e) => {
      error.innerHTML = e.message;
    });
  }).catch((e) => {
    error.innerHTML = e.message;
  });
}

// Changes the username of the current user. Called from the HTML.
function changeUsername(e) {
  let username = e.previousElementSibling.value;
  let msg = e.parentNode.querySelector('label');
  if (!!username.trim()) {
    app.usr().updateProfile({
      displayName: username
    }).then(() => {
      msg.style.color = "white";
      msg.innerHTML = "Username successfully updated!";
      updateDatabaseUser();
    }).catch((e) => {
      msg.style.color = "red";
      msg.innerHTML = e.message;
    });
  } else {
    msg.style.color = "red";
    msg.innerHTML = "Invalid username.";
  }
}

// Changes the password of the current user. Called from the HTML.
function changePassword(e) {
  let password = e.parentNode.querySelector('input[type="password"]').value;
  let msg = e.parentNode.querySelector('label');
  app.usr().updatePassword(password)
  .then(() => {
    msg.style.color = "white";
    msg.innerHTML = "Password successfully updated!";
  }).catch(e => {
    console.log(e.message);
    msg.style.color = "red";
    msg.innerHTML = e.message;
  });
}

// Updates data on Firebase Database regarding Firebase auth users
function updateDatabaseUser() {
  if (app.usr().uid) {
    firebase.database().ref(`users/${app.usr().uid}/username`).set(app.usr().displayName);
    firebase.database().ref(`users/${app.usr().uid}/email`).set(app.usr().email);
  }
}

function togglePwd(e) {
  let eye = e.nextElementSibling;
  if (e.type === 'password') {
    e.type = 'text';
    eye.classList.remove('fa-eye');
    eye.classList.add('fa-eye-slash');
  } else {
    e.type = 'password';
    eye.classList.remove('fa-eye-slash');
    eye.classList.add('fa-eye')
  }
}

function waitForDOMupdate(f) {
  intermediate = () => { window.requestAnimationFrame(f) }
  window.requestAnimationFrame(intermediate);
}
