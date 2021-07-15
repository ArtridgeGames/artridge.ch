const layouts = [
  {
    dimensions: '3x3',
    exclude: []
  },
  {
    dimensions: '4x4',
    exclude: []
  },
  {
    dimensions: '5x5',
    exclude: []
  },
  {
    dimensions: '6x6',
    exclude: []
  },
  {
    dimensions: '7x7',
    exclude: []
  },
  {
    dimensions: '8x8',
    exclude: []
  },
  {
    dimensions: '9x9',
    exclude: []
  },
  {
    dimensions: '10x10',
    exclude: []
  },
  {
    dimensions: '11x11',
    exclude: []
  },
  {
    dimensions: '12x12',
    exclude: []
  },
  {
    dimensions: '3x4',
    exclude: []
  },
  {
    dimensions: '3x5',
    exclude: []
  },
  {
    dimensions: '3x6',
    exclude: []
  },
  {
    dimensions: '3x7',
    exclude: []
  },
  {
    dimensions: '3x3',
    exclude: [3,5,6,8]
  },
  {
    dimensions: '3x3',
    exclude: [4]
  },
  {
    dimensions: '3x3',
    exclude: [1,3,5,7]
  },
  {
    dimensions: '3x3',
    exclude: [0,2,6,8]
  },
  {
    dimensions: '3x3',
    exclude: [4,7]
  },
  {
    dimensions: '4x4',
    exclude: [5,10]
  },
  {
    dimensions: '4x4',
    exclude: [3,12]
  },
  {
    dimensions: '4x4',
    exclude: [3,6,9,12]
  },
  {
    dimensions: '4x4',
    exclude: [0,3,12,15]
  },
  {
    dimensions: '4x4',
    exclude: [2,3,7,8,12,13]
  },
  {
    dimensions: '4x4',
    exclude: [0,3,6,8,12,13,15]
  },
  {
    dimensions: '4x4',
    exclude: [0,3,5,6,9,10,12,15]
  },
  {
    dimensions: '4x4',
    exclude: [0,1,4,5,10,11,14,15]
  },
  {
    dimensions: '4x4',
    exclude: [1,2,3,4,6,7,8,9,11,12,13,14]
  },
  {
    dimensions: '3x5',
    exclude: [0,2,12,14]
  },
  {
    dimensions: '5x2',
    exclude: [2,5,9]
  },
  {
    dimensions: '3x4',
    exclude: [4,6,8]
  },
  {
    dimensions: '5x5',
    exclude: [0,2,4,10,14,20,22,24]
  },
  {
    dimensions: '5x5',
    exclude: [0,2,4,10,12,14,20,22,24]
  },
  {
    dimensions: '5x5',
    exclude: [6,8,16,18]
  },
  {
    dimensions: '5x5',
    exclude: [6,8,11,13,16,18]
  },
  {
    dimensions: '5x5',
    exclude: [5,7,9,10,12,14,15,17,19]
  },
  {
    dimensions: '5x5',
    exclude: [0,2,4,7,10,11,13,14,17,20,22,24]
  },
  {
    dimensions: '5x5',
    exclude: [0,2,4,5,7,9,15,17,19,20,22,24]
  },
  {
    dimensions: '5x5',
    exclude: [0,4,5,6,8,9,15,16,18,19,20,24]
  },
  {
    dimensions: '5x5',
    exclude: [2,4,6,8,10,12,16,19,20,23,24]
  },
  {
    dimensions: '5x5',
    exclude: [0,1,5,6,7,9,10,14,15,17,18,19,23,24]
  },
  {
    dimensions: '3x3',
    exclude: [2,4,6]
  },
  {
    dimensions: '5x5',
    exclude: [0,4,20,24]
  },
  {
    dimensions: '5x5',
    exclude: [0,4,20,24,7,11,12,13,17]
  },
  {
    dimensions: '5x5',
    exclude: [2,10,14,22]
  },
  {
    dimensions: '5x5',
    exclude: [12]
  },
  {
    dimensions: '5x5',
    exclude: [1,3,5,7,9,11,13,15,17,19,21,23]
  },
  {
    dimensions: '5x5',
    exclude: [0,2,4,6,8,10,12,14,16,18,20,22,24]
  },
  {
    dimensions: '5x5',
    exclude: [7,12,17]
  },
  {
    dimensions: '5x5',
    exclude: [7,11,13,17]
  },
  {
    dimensions: '5x5',
    exclude: [1,3,5,9,11,13,15,19,21,23]
  },
  {
    dimensions: '5x5',
    exclude: [1,2,3,7,17,21,22,23]
  },
  {
    dimensions: '5x5',
    exclude: [0,1,3,4,5,6,8,9,15,16,18,19,20,21,23,24]
  },
  {
    dimensions: '4x7',
    exclude: [0,1,2,4,5,8,16,20,21,24,25,26]
  },
  {
    dimensions: '5x5',
    exclude: [5,6,7,8,13,16,17,18]
  },
  {
    dimensions: '3x5',
    exclude: [0,2,4,10,12,14]
  },
  {
    dimensions: '5x5',
    exclude: [0,1,3,4,5,9,15,19,20,21,23,24]
  },
  {
    dimensions: '7x7',
    exclude: [8,9,11,12,15,19,29,33,36,37,39,40]
  },
  {
    dimensions: '7x7',
    exclude: [0,1,5,6,7,13,35,41,42,43,47,48]
  },
    {
    dimensions: '6x6',
    exclude: [0,1,4,5,6,11,24,29,30,31,34,35]
  },
  {
    dimensions: '8x8',
    exclude: [0,1,6,7,8,15,48,55,56,57,62,63]
  },
  {
    dimensions: '5x4',
    exclude: [0,1,3,4,11,12,13,17]
  },
  {
    dimensions: '6x6',
    exclude: [0,1,3,4,5,6,10,11,12,13,15,17,18,20,27,29,30,32,33,34,35]
  },
  {
    dimensions: '7x7',
    exclude: [0,1,2,3,4,5,12,15,16,17,19,22,26,29,31,32,33,36,43,44,45,46,47,48]
  },
  {
    dimensions: '5x5',
    exclude: [1,3,6,8,10,12,14,16,18,21,23]
  },
  {
    dimensions: '7x7',
    exclude: [0,1,2,3,6,7,8,9,13,14,15,21,34,40,41,42,43,46,47,48]
  },
  {
    dimensions: '6x6',
    exclude: [0,1,2,3,4,9,10,13,14,19,21,22,23,24,25,27,28,29,33,34,35]
  },
  {
    dimensions: '5x4',
    exclude: [6,7,8,10,14]
  },
  {
    dimensions: '6x6',
    exclude: [0,1,3,4,5,6,10,11,15,17,18,20,24,25,29,30,31,32,34,35]
  },
  {
    dimensions: '5x7',
    exclude: [0,1,3,4,5,9,15,16,18,19,25,29,30,31,33,34]
  },
  {
    dimensions: '3x8',
    exclude: [4,6,8,10,13,15,17,19]
  },
  {
    dimensions: '7x7',
    exclude: [0,1,5,6,7,8,10,12,13,17,22,23,24,25,26,31,35,36,38,40,41,42,43,47,48]
  },
  {
    dimensions: '7x7',
    exclude: [0,1,5,6,7,8,10,12,13,22,24,26,35,36,38,40,41,42,43,47,48]
  },
  {
    dimensions: '7x7',
    exclude: [0,1,2,4,5,6,7,8,12,13,21,27,28,29,33,34,35,38,41,44,45,46]
  },
  {
    dimensions: '7x7',
    exclude: [2,4,10,14,16,17,18,20,22,23,24,25,26,28,30,31,32,34,38,44,46]
  },
  {
    dimensions: '5x6',
    exclude: [2,6,8,11,12,13,16,17,18,21,23,27]
  },
  {
    dimensions: '7x7',
    exclude: [0,1,2,4,5,6,7,8,12,13,14,20,28,34,35,36,40,41,42,43,44,46,47,48]
  },
  {
    dimensions: '7x9',
    exclude: [0,1,5,6,7,8,10,12,13,14,15,17,19,20,21,22,23,25,26,27,29,33,34,35,37,39,41,42,43,44,46,47,49,50,52,54,55,56,57,59,61,62]
  },
  {
    dimensions: '9x9',
    exclude: [0,1,2,3,4,5,7,8,9,10,11,12,13,14,17,18,19,20,21,22,23,24,26,27,28,29,30,31,32,33,36,37,38,39,40,41,45,46,47,48,49,56,57,62,63,71,72,73,74,78,79,80]
  },
  {
    dimensions: '11x8',
    exclude: [0,1,3,4,5,6,7,9,10,11,12,13,15,16,17,19,20,21,22,23,31,32,33,36,40,43,56,64,67,69,70,71,72,73,75,77,78,79,82,85,86,87]
  },
  {
    dimensions: '9x9',
    exclude: [0,1,2,9,10,11,18,19,20,6,7,8,15,16,17,24,25,26,54,55,56,63,64,65,72,73,74,60,61,62,69,70,71,78,79,80,3,5,21,23,27,29,45,47,33,35,51,53,57,59,75,77]
  }
];
layouts.forEach(e => {
  const dimensions = e.dimensions.split('x');
  e.width = parseInt(dimensions[0]);
  e.height = parseInt(dimensions[1]);
});

const puzzles = [
  {
    moves: 20,
    base: [
      [0,1,1,1],
      [1,0,1,1],
      [1,1,0,1],
      [1,1,1,0]
    ],
    target: [
      [1,1,1,0],
      [1,1,0,1],
      [1,0,1,1],
      [0,1,1,1]
    ]
  },
  {
    moves: 12,
    base: [
      [2,1,1,2],
      [0,2,2,0],
      [0,2,2,0],
      [2,1,1,2]
    ],
    target: [
      [2,0,0,2],
      [1,2,2,1],
      [1,2,2,1],
      [2,0,0,2]
    ]
  },
  {
    moves: 4,
    base: [
      [1,2,2,2],
      [2,0,2,2],
      [2,2,1,2],
      [2,2,2,1]
    ],
    target: [
      [1,2,2,2],
      [2,1,2,2],
      [2,2,0,2],
      [2,2,2,1]
    ]
  },
  {
    moves: 10,
    base: [
      [2,1,2],
      [0,0,0],
      [0,1,0],
      [0,0,0],
      [2,1,2]
    ],
    target: [
      [2,1,2],
      [0,0,0],
      [0,0,0],
      [0,0,0],
      [2,1,2]
    ]
  },
  {
    moves: 20,
    base: [
      [0,1,0],
      [0,2,0],
      [2,1,2],
      [0,1,0]
    ],
    target: [
      [1,1,1],
      [0,2,0],
      [2,0,2],
      [0,1,0]
    ]
  },
  {
    moves: 4,
    base: [
      [1,2,1],
      [2,0,2],
      [1,2,1]
    ],
    target: [
      [0,2,0],
      [2,0,2],
      [0,2,0]
    ]
  },
  {
    moves: 30,
    base: [
      [2,0,2,1,2],
      [2,1,2,0,2],
      [1,1,1,1,0],
      [2,0,2,1,2],
      [2,1,2,1,2]
    ],
    target: [
      [2,1,2,1,2],
      [2,1,2,1,2],
      [0,0,0,0,0],
      [2,1,2,1,2],
      [2,1,2,1,2]
    ]
  },
  {
    moves: 3,
    base: [
      [0,1,2],
      [1,2,0],
      [2,0,0]
    ],
    target: [
      [1,1,2],
      [1,2,0],
      [2,0,0]
    ]
  },
  {
    moves: 8,
    base: [
      [1,1,1,2],
      [1,0,0,1],
      [1,0,0,1],
      [2,1,1,1]
    ],
    target: [
      [1,1,1,2],
      [1,1,0,1],
      [1,0,1,1],
      [2,1,1,1]
    ]
  }
]

const dirx = [0,0,0,1,-1,-1,1,-1,1];
const diry = [0,1,-1,0,0,-1,-1,1,1];
const copy = (val) => JSON.parse(JSON.stringify(val));

let currentLayout = copy(layouts[0]);
let currentLayoutIndex = 0;
let counter = 0;

const app = new Vue({
  el: '#app',
  data: {
    screen: 'menu',
    currentChallenge: '',
    gameModes: [
      {
        title: 'freeplay',
        fn: () => {
          app.screen = 'layouts'
        }
      },
      {
        title: 'puzzles',
        fn: () => {
          app.screen = 'puzzles-selection'
        }
      },
      {
        title: 'challenges',
        fn: () => {
          app.screen = 'challenges'
        }
      }
    ]
  },
  methods: {
    openScreen(screen) {
      this.screen = screen;
    }
  }
});

// Splash screen animation
(() => {
  window.addEventListener('load', () => {
    const splashScreen = document.querySelector('.splash-screen');
    splashScreen.style.display = 'none';
    window.setTimeout(() => {
      splashScreen.style.opacity = '0';
      window.setTimeout(() => {
        splashScreen.style.display = 'none';
      }, 1e3)
    }, 2e3);
  });
})();

function updateLayout(layout) {

  currentLayout = layout || currentLayout;

  updateTileSize();

  const tiles = document.querySelectorAll('button.tile');

  let tileIndex = 0;
  const container = document.querySelector('#container');
  container.innerHTML = '';
  for (let i = 0; i < currentLayout.height; i++) {
    const row = document.createElement('div');
    row.classList.add('row');
    for (let j = 0; j < currentLayout.width; j++) {
      let tile = document.createElement('button');
      tile.classList.add('tile');
      tile.setAttribute('data-index', tileIndex);

      if (currentLayout.exclude.includes(tileIndex)) {
        tile.setAttribute('data-disabled', true);
      } else {
        const index = tileIndex
        tile.addEventListener('ontouchstart' in document.documentElement ? 'touchstart' : 'click', (e) => {
          e.preventDefault();
          counter++;
          press(index);
        });
        tile.setAttribute('data-disabled', false);
      }
      row.appendChild(tile);
      tileIndex++;
    }
    container.appendChild(row);
  }
}

function press(index, preventAnim, preventWin) {

  const tiles = document.querySelectorAll('button.tile');

  for (let i = 0; i < dirx.length; i++) {
    var tileX = (index % currentLayout.width) + diry[i];
    var tileY = Math.floor(index / currentLayout.width) + dirx[i];
    if (tileX >= 0 && tileX < currentLayout.width && tileY >= 0 && tileY < currentLayout.height) {
      const tile = tiles[(tileY * currentLayout.width) + tileX];
      const col = tile.getAttribute('data-col');
      if (col === 'black') {
        tile.setAttribute('data-col', 'white');
      } else {
        tile.setAttribute('data-col', 'black');
      }
      if (!preventAnim) {
        const duration = 0.3;
        const delay = 0.08;
        TweenMax.to(tile, duration, {scaleY: 1.6, ease: Expo.easeOut});
        TweenMax.to(tile, duration, {scaleX: 1.2, scaleY: 1, ease: Back.easeOut, easeParams: [3], delay: delay});
        TweenMax.to(tile, duration * 1.25, {scaleX: 1, scaleY: 1, ease: Back.easeOut, easeParams: [6], delay: delay * 3 });
      }
    }
  }
  let won = true;
  if (app.screen === 'puzzles') {

    won = JSON.stringify(getGrid()) === JSON.stringify(currentLayout.target);
    
    updateMovesRemaining(won);
    
  } else {
    for (let i = 0; i < tiles.length; i++) {
      if (tiles[i].getAttribute('data-col') === 'black' && tiles[i].getAttribute('data-disabled') === 'false') {
        won = false;
      }
    }
  }
  if (won && !preventWin) {
    window.setTimeout(function() {
      document.querySelectorAll('.popup span')[0].innerHTML = counter;

      document.querySelectorAll('.popup')[0].style.transform = 'translate(-50%,-50%) scale(1)';
      document.querySelectorAll('.background')[0].style.display = 'block';

      window.setTimeout(() => {
        document.querySelectorAll('.background')[0].style.opacity = '1';
      }, 10);

      counter = 0;
    }, 50);
  }
}

function closePopup(i) {
  document.querySelectorAll('.popup')[i].style.transform = 'translate(-50%,-50%) scale(0)';
  document.querySelectorAll('.background')[i].style.opacity = '0';
  window.setTimeout(() => {
    document.querySelectorAll('.background')[i].style.display = 'none';
  }, 300);

  if (i === 0) {
    randomize(true);
    if (app.screen === 'puzzles') {
      app.openScreen('puzzles-selection');
    }
  }
}

window.setInterval(() => {
  const slider = document.getElementById('slider');
  const difficulties = ['very easy', 'easy', 'normal', 'hard', 'very hard'];
  document.getElementById('difficulty').innerHTML = difficulties[Math.floor((slider.value - 1) / (slider.max/difficulties.length))];
}, 50)

function randomize(preventAnim) {
  updateLayout();

  const tiles = document.querySelectorAll('button.tile');

  for (let i = 0; i < tiles.length; i++) {
    tiles[i].setAttribute('data-col', 'white');
  }

  const previousTiles = [];
  for (let i = 0; i < document.getElementById('slider').value; i++) {
    let index;
    while (true) {
      index = Math.floor(Math.random() * currentLayout.width * currentLayout.height);
      if (!currentLayout.exclude.includes(index) && !previousTiles.includes(index)) {
        press(index, preventAnim, true);
        previousTiles.push(index);
        if (previousTiles.length > 3) previousTiles.splice(0,1);
        break;
      }
    }
  }
  counter = 0;

  let allWhite = true;
  let allBlack = true;
  for (let i = 0; i < tiles.length; i++) {
    const t = tiles[i];
    if (t.getAttribute('data-col') === 'white') allBlack = false;
    if (t.getAttribute('data-col') === 'black') allWhite = false;
  }
  if (allWhite || allBlack) randomize(preventAnim);
}

function setLayout(i) {
  currentLayout = copy(layouts[i === undefined ? Math.floor(Math.random() * layouts.length) : i])
  updateLayout();
}

function changeLayout() {
  document.querySelectorAll('.popup')[1].style.transform = 'translate(-50%,-50%) scale(1)';
  document.querySelectorAll('.background')[1].style.display = 'block';
  window.setTimeout(() => {
    document.querySelectorAll('.background')[1].style.opacity = '1';
  },10);
}

updateLayout();
randomize(true);

if ('ontouchstart' in document.documentElement) {
  document.addEventListener('touchstart', (e) => {
    e.preventDefault();
  });
}

(() => {
  const func = (e) => {
    let parent = document.querySelector('#controls');
    let buttons = parent.querySelector('.buttons');
    let difficulty = parent.querySelector('.difficulty');
    if (window.innerWidth > window.innerHeight) {
      parent.insertBefore(buttons, difficulty);
    } else {
      parent.insertBefore(difficulty, buttons);
    }

    updateTileSize();
  }
  window.addEventListener('resize', func);
  window.addEventListener('load', func);
})();

function updateTileSize() {
  if (window.innerWidth > window.innerHeight) {
    const width = 1 / Math.max(currentLayout.width, 6) * 450 * Math.max(window.innerWidth / 1500, 1);
    document.documentElement.style.setProperty('--tile-size', width + 'px');
  }
}

(() => {
  let layoutsContainer = document.querySelector('.screen.layouts .layout-container');

  for (let i = 0; i < layouts.length; i++) {
    const layout = layouts[i];
    
    let el = document.createElement('div');
    el.classList.add('button');
    
    let index = 0;
    const tileSize = 1 / Math.sqrt(layout.height * layout.width) * 60;
    for (let y = 0; y < layout.height; y++) {
      for (let x = 0; x < layout.width; x++) {
        if (!layout.exclude.includes(index)) {
          let square = document.createElement('div');

          let xPos = x * tileSize + 50 - layout.width * tileSize / 2;
          let yPos = y * tileSize + 50 - layout.height * tileSize / 2;

          square.style.transform = `translate(${xPos}px, ${yPos}px)`;
          square.style.width = `${tileSize - 1}px`;
          square.style.height = `${tileSize - 1}px`;

          el.appendChild(square);
        }
        index++;
      }
    }

    el.addEventListener('click', () => {
      app.openScreen('freeplay')
      setLayout(i);
      randomize(true);
    });

    layoutsContainer.appendChild(el);
  }
})();

(() => {
  const container = document.querySelector('.screen.puzzles .layout-container');
  for (const puzzle of puzzles) {

    let index = 0;
    const exclude = [];
    for (const row of puzzle.base) {
      for (const tile of row) {
        if (tile === 2) {
          exclude.push(index)
        }
        index++;
      }
    }

    const width = puzzle.base[0].length;
    const height = puzzle.base.length;

    const el = document.createElement('div');
    el.classList.add('button');

    index = 0;
    const tileSize = 1 / Math.sqrt(height * width) * 60;
    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        if (!exclude.includes(index)) {
          let square = document.createElement('div');

          let xPos = x * tileSize + 50 - width * tileSize / 2;
          let yPos = y * tileSize + 50 - height * tileSize / 2;

          square.style.transform = `translate(${xPos}px, ${yPos}px)`;
          square.style.width = `${tileSize - 1}px`;
          square.style.height = `${tileSize - 1}px`;

          if (puzzle.base[y][x] === 1) square.style.backgroundColor = 'var(--greige)';

          el.appendChild(square);
        }
        index++;
      }
    }

    el.addEventListener('click', () => {
      app.openScreen('puzzles');
      
      const layout = {
        width,
        height,
        exclude
      }
      layout.target = puzzle.target;
      layout.base = puzzle.base;
      layout.moves = puzzle.moves;
      
      updateLayout(layout);
      setState(puzzle.base);

      const targetContainer = document.querySelector('.puzzle-target');
      targetContainer.innerHTML = '';
      for (const row of puzzle.target) {
        const rowEl = document.createElement('div');
        rowEl.classList.add('row');
        for (const tile of row) {
          const tileEl = document.createElement('div');
          tileEl.classList.add('tile');
          if (tile === 2) {
            tileEl.setAttribute('data-disabled', 'true');
          } else {
            tileEl.setAttribute('data-disabled', 'false');
            tileEl.setAttribute('data-col', tile === 1 ? 'white' : 'black')
          }
          rowEl.append(tileEl);
        }
        targetContainer.append(rowEl);
      }

      counter = 0;

      updateMovesRemaining();
    });

    container.appendChild(el);
  }
})();

function updateMovesRemaining(won) {
  const h1 = document.querySelector('.puzzle-info h1');
  const movesRemaining = currentLayout.moves - counter;

  if (movesRemaining === 0 && !won) {
    document.querySelectorAll('.popup')[1].style.transform = 'translate(-50%,-50%) scale(1)';
    document.querySelectorAll('.background')[1].style.display = 'block';

    window.setTimeout(() => {
      document.querySelectorAll('.background')[1].style.opacity = '1';
    }, 10);
  }
  h1.textContent = `${movesRemaining} moves remaining`;
}

function retryPuzzle() {
  setState(currentLayout.base);
  counter = 0;

  updateMovesRemaining();
}

function selectChallenge(challenge) {
  app.currentChallenge = challenge;
}

function setAll(white) {
  document.querySelectorAll('.tile').forEach(e => {
    e.setAttribute('data-col', white ? 'white' : 'black')
  });
}

function pressAll() {
  document.querySelectorAll('.tile').forEach((e, i) => {
    if (e.getAttribute('data-disabled') === 'false') {
      press(i, true, true);
    }
  });
}

function pressOnGrid(grid, index) {
  grid = copy(grid);
  
  const width = grid[0].length;
  const height = grid.length;

  for (let i = 0; i < dirx.length; i++) {
    const tileX = (index % width) + diry[i];
    const tileY = Math.floor(index / width) + dirx[i];
    if (tileX >= 0 && tileX < width && tileY >= 0 && tileY < height) {
      if (grid[tileY][tileX] === 0) {
        grid[tileY][tileX] = 1;
      } else {
        grid[tileY][tileX] = 0;
      }
    }
  }

  return grid;
}

function solveCurrentGrid() {
  return solveGrid(getGrid());
}

function solveGrid(grid) {
  originalGrid = copy(grid);

  const width = grid[0].length;
  const height = grid.length;
  const size = width * height;

  const array = [];
  for (let i = 0; i < size; i++) {
    array.push(i);
  }

  let movePatterns = []
  for (let i = 1; i <= size; i++) {
    const perm = getPermutations(array, i);
    for (pattern of perm) {
      grid = copy(originalGrid);
      moves = [];
      for (index of pattern) {
        const tileX = (index % width);
        const tileY = Math.floor(index / width);
        if (grid[tileY][tileX] !== 2) {
          grid = pressOnGrid(grid, index);
          moves.push(index);
        }
        if (isGridSolved(grid)) {
          movePatterns.push(moves);
          moves = [];
        }
      }
    }
  }
  return movePatterns;
}

function setState(grid) {
  if (typeof grid === 'string') {
    setState(stringToGrid(grid));
  } else {
    const tiles = document.querySelectorAll('button.tile');
    let index = 0;
    for (row of grid) {
      for (cell of row) {
        if (cell === 2) {
          tiles[index].setAttribute('data-disabled', 'true');
        } else {
          tiles[index].setAttribute('data-disabled', 'false');
        }
        tiles[index].setAttribute('data-col', cell ? 'white' : 'black')
        index++;
      }
    }
  }
}

function isSolved() {
  return isGridSolved(getGrid());
}

function isGridSolved(grid) {
  let allWhite = true;
  for (row of grid) {
    for (tile of row) {
      if (tile !== 1) allWhite = false;
    }
  }
  return allWhite;
}

function getPermutations(array, size) {

  function p(t, i) {
      if (t.length === size) {
          result.push(t);
          return;
      }
      if (i + 1 > array.length) {
          return;
      }
      p(t.concat(array[i]), i + 1);
      p(t, i + 1);
  }

  var result = [];
  p([], 0);
  return result;
}

function getGrid() {
  const rows = document.querySelectorAll('#main .row');
  const grid = [];
  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    const tiles = row.querySelectorAll('button.tile');
    const arr = [];
    for (let j = 0; j < tiles.length; j++) {
      const tile = tiles[j];
      if (tile.getAttribute('data-disabled') === 'true') {
        arr.push(2);
      } else {
        if (tile.getAttribute('data-col') === 'white') {
          arr.push(1);
        } else {
          arr.push(0);
        }
      }
    }
    grid.push(arr);
  }
  return grid;
}

function getAllStates() {
  const size = currentLayout.width * currentLayout.height;
  const max = parseInt("1".repeat(size), 2);
  const states = [];
  for (let i = 0; i < max; i++) {
    states.push(i.toString(2).padStart(size, '0'))
  }
  return states;
}

function stringToGrid(str) {
  const grid = [];
  const w = currentLayout.width;
  for (let i = 0; i < str.length; i += w) {
    grid.push(str.slice(i, i + w).split('').map(e => parseInt(e)));
  }
  return grid;
}

function gridToString(grid) {
  let str = '';
  for (row of grid) {
    for (cell of row) {
      str += cell;
    }
  }
  return str;
}

function getHardestLayout() {
  const allLayouts = getAllStates();
  const allMoves = [];
  let sum = 0;
  let longest = 0;
  for (let i = 0; i < allLayouts.length; i++) {
    let layout = allLayouts[i];
    layout = stringToGrid(layout)

    setState(layout);

    const solutions = solveCurrentGrid();
    let min = solutions[0]?.length;
    for (solution of solutions) {
      if (solution.length < min) min = solution.length;
    }
    if (min > longest) longest = min;
    allMoves.push(min);
    sum += min;
  }
  console.log('LONGEST: ', longest);
  console.log('AVERAGE: ', sum / allMoves.length);
  return allMoves;
}

function help() {
  console.table({
    'setAll(white)': 'sets all the tiles of the current layout to black, or white if the first parameter is truthy',
    'getGrid()': 'returns a bidimentional representation of the current grid',
    'setState()': 'sets the state of the current layout to the grid passed as the first parameter',
    'isGridSolved(grid)': 'checks if the grid passed as the first parameter is solved',
    'isSolved()': 'checks if the current layout is solved',
    'solveGrid(grid)': 'returns an array of possible move combinations that can solve the grid passed as parameter',
    'solveCurrentGrid()': 'executes solveGrid on the current layout',
    'pressOnGrid(grid, index)': 'returns a copy of the grid passed as parameter after performing a press at the given index',
    'pressAll()': 'presses each tile of the current layout'
  })
}
