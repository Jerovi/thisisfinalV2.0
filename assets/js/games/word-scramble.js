/**
 * Agri-Scramble Game - NIR Edition
 * Unscramble words related to Negros Island Region crops and farming!
 * Features an educational explanation popup after every correct word.
 */

let gameCanvas, ctx;
let gameState = 'ready'; // ready, playing, explaining, ended
let score = 0;
let currentWordObj = null;
let currentWord = '';
let scrambledWord = '';
let userInput = '';
let timeLeft = 60;
let wordsCompleted = 0;
let streak = 0;
let gameConfig;
let timerInterval;
let lastWordScore = 0; // To show on the explanation screen
let lives = 3;         // Player starts with 3 lives
let level = 1;         // Current level
const WORDS_PER_LEVEL = 3; // Words needed to level up
const MAX_LIVES = 3;
let showLevelUpBanner = false;
let levelUpBannerTimer = 0;

// Word lists by difficulty - Includes hints and post-success explanations!
const wordLists = {
    easy: [
        { word: 'RICE', hint: 'A staple grain grown in flatlands.', explanation: 'Negros produces significant amounts of rice in its flatlands to ensure local food security.' },
        { word: 'CORN', hint: 'A major alternative staple and poultry feed.', explanation: 'Corn is a vital crop for the local poultry and livestock feed industry in the region.' },
        { word: 'FISH', hint: 'Caught daily by local coastal communities.', explanation: 'Coastal towns in Negros rely heavily on fishing for their daily livelihood and food supply.' },
        { word: 'PIG', hint: 'Common backyard livestock.', explanation: 'Swine raising is a very common backyard industry for rural families in the region.' },
        { word: 'COW', hint: 'Cattle raised for dairy and beef.', explanation: 'Cattle are raised for beef and dairy, with some local farms producing fresh organic milk.' },
        { word: 'FARM', hint: 'A piece of land dedicated to agriculture.', explanation: 'Farms are the backbone of the Negros economy, providing jobs and food for the region.' },
        { word: 'SOIL', hint: 'The fertile earth in which crops are planted.', explanation: 'The volcanic soil near Mt. Kanlaon is incredibly fertile, making it perfect for agriculture.' },
        { word: 'CROP', hint: 'Cultivated plants grown for food or profit.', explanation: 'The region diversifies its crops to ensure farmers have income even when sugar prices drop.' },
        { word: 'MILK', hint: 'Fresh dairy product from local cattle.', explanation: 'There is a growing local dairy industry in Negros pushing for fresh, locally-sourced milk.' },
        { word: 'EGG', hint: 'Produced daily by local poultry farms.', explanation: 'Poultry farming provides a steady daily supply of fresh eggs to local markets and bakeries.' },
        // New Easy Words
        { word: 'SEED', hint: 'Planted in the soil to grow.', explanation: 'Farmers carefully select high-quality seeds to ensure a bountiful harvest across the island.' },
        { word: 'GOAT', hint: 'Small livestock raised for meat and milk.', explanation: 'Goat farming is popular in rural Negros for both dairy and the famous dish, kaldereta.' },
        { word: 'DUCK', hint: 'Waterfowl raised for eggs.', explanation: 'Duck raising provides the region with eggs for popular local delicacies like balut and salted eggs.' },
        { word: 'TREE', hint: 'A tall woody plant.', explanation: 'Fruit-bearing trees provide essential shade and secondary income for local agricultural workers.' },
        { word: 'ROOT', hint: 'The underground part of a plant.', explanation: 'Root crops are vital for food security, especially in the mountainous areas of the province.' },
        { word: 'RAIN', hint: 'Natural water from the sky.', explanation: 'Seasonal rains dictate the planting schedules for most agricultural workers in the region.' },
        { word: 'PORK', hint: 'Meat from a pig.', explanation: 'Negros produces a large volume of pork to supply the high local demand for lechon and daily consumption.' },
        { word: 'BEEF', hint: 'Meat from cattle.', explanation: 'Ranches in the region supply beef to local markets and restaurants across the island.' },
        { word: 'LEAF', hint: 'The green part of a plant that makes food.', explanation: 'Banana and taro leaves are often used in local food preparation and eco-friendly packaging.' },
        { word: 'BEAN', hint: 'A legume grown for food.', explanation: 'Various beans are planted as rotation crops to naturally restore nitrogen to the sugarcane fields.' },
        { word: 'YAM', hint: 'A starchy tuber crop.', explanation: 'Ube, a type of yam, is grown and processed into popular purple desserts across the region.' },
        { word: 'TARO', hint: 'A tropical root vegetable.', explanation: 'Locally known as gabi, this root crop thrives in the wet, marshy areas of Negros.' },
        { word: 'PLOW', hint: 'Tool used to turn soil.', explanation: 'Traditional farmers still use carabao-drawn plows in areas where modern tractors cannot reach.' },
        { word: 'HOE', hint: 'Hand tool for weeding and digging.', explanation: 'An essential hand tool used daily by farm laborers to maintain crop fields.' },
        { word: 'WEED', hint: 'Unwanted plant in a farm.', explanation: 'Manual weeding provides daily wage labor for many agricultural workers in the province.' },
        { word: 'POND', hint: 'Small body of water for fish.', explanation: 'Inland aquaculture utilizes freshwater ponds to raise fish for inland communities far from the coast.' },
        { word: 'DIRT', hint: 'Earth or soil.', explanation: 'The rich volcanic dirt from the local mountain ranges makes the surrounding land highly productive.' },
        { word: 'MEAT', hint: 'Animal flesh eaten as food.', explanation: 'The robust livestock sector ensures a steady supply of meat for the growing population.' },
        { word: 'SUN', hint: 'Source of light and heat.', explanation: 'Abundant sunshine is critical for the photosynthesis of large-scale sugarcane plantations.' },
        { word: 'HEN', hint: 'A female chicken.', explanation: 'Layer hens are crucial for maintaining the daily egg supply for local markets and bakeries.' }
    ],
    medium: [
        { word: 'SUGAR', hint: 'The primary agricultural product of Negros.', explanation: 'Negros produces over half of the total sugar output of the Philippines, driving its economy.' },
        { word: 'COPRA', hint: 'Dried coconut meat.', explanation: 'Coconut farmers dry the meat into copra, which is then pressed into valuable coconut oil.' },
        { word: 'CACAO', hint: 'Pods processed locally to make tablea.', explanation: 'Local farmers are increasingly planting cacao to produce high-quality artisanal chocolates.' },
        { word: 'COFFEE', hint: 'Grown in the cool highlands of Mt. Kanlaon.', explanation: 'High-altitude areas like La Castellana produce excellent Robusta and Arabica coffee blends.' },
        { word: 'MANGO', hint: 'A sweet tropical fruit heavily exported.', explanation: 'Guimaras and Negros produce some of the sweetest export-quality mangoes in the world.' },
        { word: 'BANANA', hint: 'The Saba variety is very common locally.', explanation: 'Saba bananas are grown everywhere and are a key ingredient in local delicacies like turon.' },
        { word: 'PAPAYA', hint: 'A healthy tropical fruit grown year-round.', explanation: 'A fast-growing tropical fruit that provides farmers with a quick and steady harvest.' },
        { word: 'FARMER', hint: 'The hardworking people who grow our food.', explanation: 'Farmers are the backbone of the region, dedicating their lives to feeding the community.' },
        { word: 'CATTLE', hint: 'Livestock raised in local ranches.', explanation: 'Commercial ranches and smallholders alike raise cattle to supply the local meat markets.' },
        { word: 'POULTRY', hint: 'Farms dedicated to raising chickens.', explanation: 'The poultry industry supplies the massive demand for chicken in local restaurants like Inasal.' },
        // New Medium Words
        { word: 'CARABAO', hint: 'The traditional beast of burden.', explanation: 'Often seen in muddy fields, it is the classic symbol of Philippine agriculture and a farmer\'s best friend.' },
        { word: 'PEANUT', hint: 'A groundnut often boiled or roasted.', explanation: 'Peanuts are commonly grown as a cash crop in the sandy soils of some Negros municipalities.' },
        { word: 'CASSAVA', hint: 'A drought-resistant root crop.', explanation: 'This starchy root is processed into flour or eaten as a traditional snack in rural areas.' },
        { word: 'GARLIC', hint: 'A pungent bulb used in cooking.', explanation: 'A staple spice in Negrense cuisine, often planted alongside other cash crops to maximize space.' },
        { word: 'TOMATO', hint: 'A red fruit used as a vegetable.', explanation: 'Grown in cooler elevated areas, supplying local markets with fresh ingredients for daily dishes.' },
        { word: 'SQUASH', hint: 'A large, hard-skinned vegetable.', explanation: 'Locally called kalabasa, it is a hardy crop that provides excellent nutrition to farming families.' },
        { word: 'GINGER', hint: 'A spicy root used for flavoring.', explanation: 'Grown extensively in the highlands, it is heavily used in local broths like tinola.' },
        { word: 'ONION', hint: 'A layered bulb vegetable.', explanation: 'While challenging to grow, local agricultural initiatives are pushing for higher production in the region.' },
        { word: 'RABBIT', hint: 'Small mammal increasingly raised for meat.', explanation: 'Rabbit farming is an emerging alternative livestock industry gaining traction for its low environmental footprint.' },
        { word: 'BAMBOO', hint: 'A fast-growing woody grass.', explanation: 'Crucial for farm infrastructure, it is used to build everything from animal pens to rest huts.' },
        { word: 'TRACTOR', hint: 'A heavy farm vehicle.', explanation: 'Modernization in the sugar industry heavily relies on these machines for plowing massive farmlands.' },
        { word: 'ORCHARD', hint: 'A farm dedicated to fruit trees.', explanation: 'Many sugarcane farmers are diversifying by converting parts of their land into fruit orchards.' },
        { word: 'PASTURE', hint: 'Grassy land for grazing animals.', explanation: 'Expansive pastures in the region support the growing cattle and dairy industries.' },
        { word: 'MARKET', hint: 'Where farmers sell their produce.', explanation: 'Local "bagsakan" or wholesale markets are the lifeblood of agricultural trade in the province.' },
        { word: 'EXPORT', hint: 'Sending goods to another country.', explanation: 'Negros has a long history of exporting high-value goods like sugar and premium molasses.' },
        { word: 'COCONUT', hint: 'The tree of life.', explanation: 'Abundant along the coastlines, providing timber, copra, and fresh juice for locals and tourists.' },
        { word: 'CITRUS', hint: 'Fruits like lemons and calamansi.', explanation: 'Calamansi orchards are profitable ventures, supplying the massive local restaurant industry.' },
        { word: 'GUAVA', hint: 'A tropical fruit with edible seeds.', explanation: 'Often grown in backyards, it is eaten fresh or used as a souring agent in local soups like sinigang.' },
        { word: 'CHICKEN', hint: 'The most common farm bird.', explanation: 'Native chicken farming is a prized industry, specifically to supply authentic ingredients for Chicken Inasal.' },
        { word: 'SEAFOOD', hint: 'Edible aquatic animals.', explanation: 'Coastal cities in NIR boast rich seafood catches, supporting a vibrant culinary tourism sector.' }
    ],
    hard: [
        { word: 'SUGARCANE', hint: "The tall grass crop that drives the economy.", explanation: "Known as the 'Sugarbowl of the Philippines', this tall grass crop dominates the Negros landscape." },
        { word: 'MUSCOVADO', hint: 'Unrefined local sugar with a rich flavor.', explanation: 'This healthy, unrefined sugar retains its natural molasses and is a specialty of Antique and Negros.' },
        { word: 'MILKFISH', hint: 'Heavily farmed in coastal ponds (Bangus).', explanation: 'Also known as Bangus, it is heavily farmed in coastal brackish water ponds across the region.' },
        { word: 'ROBUSTA', hint: 'A hardy coffee bean variety.', explanation: 'This hardy coffee bean thrives in the lower mountain elevations of the Negros Island Region.' },
        { word: 'HACIENDA', hint: 'Large agricultural estates in Negros.', explanation: 'These large agricultural estates are a historical and major part of the Negros sugar industry.' },
        { word: 'ORGANIC', hint: 'Farming without synthetic chemicals.', explanation: 'Negros Island is heavily recognized as the organic agriculture capital of the Philippines.' },
        { word: 'TILAPIA', hint: 'Freshwater fish raised in inland aquaculture.', explanation: 'A fast-growing freshwater fish that provides a cheap and rich protein source for locals.' },
        { word: 'HARVEST', hint: 'The seasonal process of gathering crops.', explanation: 'The sugarcane harvest season, known locally as "Tiempo Suerte", is a busy time for the region.' },
        { word: 'LIVESTOCK', hint: 'Farm animals raised for food and labor.', explanation: 'Raising farm animals acts as a living savings account for many rural Negrosanon families.' },
        { word: 'IRRIGATION', hint: 'Artificial application of water to crops.', explanation: 'Proper water management is crucial for local farms to survive the intense dry summer months.' },
        // New Hard Words
        { word: 'FERTILIZER', hint: 'Substance added to soil to boost growth.', explanation: 'Both synthetic and organic fertilizers are strictly managed to maximize the yield of sugarcane fields.' },
        { word: 'AQUACULTURE', hint: 'Farming of aquatic organisms.', explanation: 'The region utilizes extensive fishponds to cultivate bangus, tilapia, and prawns for commercial trade.' },
        { word: 'PLANTATION', hint: 'A large estate for cash crops.', explanation: 'The geography of Negros Island is dominated by vast agricultural plantations stretching across the plains.' },
        { word: 'REFINERY', hint: 'A facility that processes raw materials.', explanation: 'Sugar refineries in the province process raw cane into the white sugar found in grocery stores worldwide.' },
        { word: 'MOLASSES', hint: 'Thick, dark syrup from sugar processing.', explanation: 'A valuable byproduct of sugar milling, it is exported for animal feed or distilled into alcohol.' },
        { word: 'COOPERATIVE', hint: 'An enterprise owned by its members.', explanation: 'Agrarian reform beneficiaries often form cooperatives to pool resources and effectively manage large farmlands.' },
        { word: 'SUSTAINABLE', hint: 'Farming that maintains ecological balance.', explanation: 'There is a strong movement in the region towards sustainable methods to preserve soil health for future generations.' },
        { word: 'PESTICIDE', hint: 'Chemical used to kill crop-destroying insects.', explanation: 'Modern agriculture balances the use of these chemicals to protect yields while minimizing environmental impact.' },
        { word: 'GREENHOUSE', hint: 'Glass or plastic building for growing plants.', explanation: 'High-value crops like lettuce and strawberries are grown in these controlled environments in the highlands.' },
        { word: 'WATERMELON', hint: 'A large, watery summer fruit.', explanation: 'A popular rotation crop planted after the sugar harvest to utilize the land during the dry summer months.' },
        { word: 'CALAMANSI', hint: 'A small, native citrus fruit.', explanation: 'This ubiquitous Philippine lime is heavily farmed to meet the massive demand of the food and beverage sector.' },
        { word: 'JACKFRUIT', hint: 'The largest tree-borne fruit.', explanation: 'Locally known as langka, it is grown for both its sweet ripe fruit and its use as a vegetable when unripe.' },
        { word: 'RAMBUTAN', hint: 'A red, hairy tropical fruit.', explanation: 'Seasonal fruit farms in the region attract tourists who pay to pick and eat these sweet fruits straight from the tree.' },
        { word: 'MANGROVE', hint: 'Coastal trees that protect shorelines.', explanation: 'Conservation of these forests is vital as they serve as nurseries for the local wild fishing industry.' },
        { word: 'VETERINARY', hint: 'Medical care for animals.', explanation: 'Access to good animal healthcare is crucial to prevent disease outbreaks in the region\'s large poultry and swine farms.' },
        { word: 'AGRICULTURE', hint: 'The science and practice of farming.', explanation: 'This remains the primary economic driver and largest employer for the entire Negros Island Region.' },
        { word: 'AGRIBUSINESS', hint: 'Commercial farming and related industries.', explanation: 'The transition from simple farming to complex commercial enterprises is elevating the local economy.' },
        { word: 'CENTRIFUGAL', hint: 'Machine used to separate sugar crystals.', explanation: 'A critical piece of industrial equipment inside every active sugar mill in the province.' },
        { word: 'AGRARIAN', hint: 'Relating to cultivated land.', explanation: 'Land reform programs have shaped the modern landscape by distributing parcels to local farm workers.' },
        { word: 'LANZONES', hint: 'Pale yellow, grape-like tropical fruit.', explanation: 'Orchards dedicated to this seasonal fruit provide a highly anticipated and lucrative late-summer harvest.' }
    ]
};

let words = [];
let usedWords = [];

function initGame(container, config) {
    gameConfig = config;
    words = [...wordLists[config.difficulty] || wordLists.medium];
    
    gameCanvas = document.createElement('canvas');
    gameCanvas.id = 'word-scramble-canvas';
    gameCanvas.style.width = '100%';
    gameCanvas.style.height = '100%';
    container.appendChild(gameCanvas);
    ctx = gameCanvas.getContext('2d');
    
    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);
    setupInputHandlers();
    showStartScreen();
}

function resizeCanvas() {
    const rect = gameCanvas.parentElement.getBoundingClientRect();
    gameCanvas.width = rect.width;
    gameCanvas.height = rect.height;
    
    if (gameState === 'playing' || gameState === 'explaining') {
        render();
    }
}

function setupInputHandlers() {
    document.addEventListener('keydown', (e) => {
        if (gameState === 'ready' && e.key === ' ') {
            startGame();
            return;
        }
        
        // Handle proceeding to the next word after reading the explanation
        if (gameState === 'explaining' && e.key === 'Enter') {
            nextWord();
            return;
        }
        
        if (gameState !== 'playing') return;
        
        if (e.key === 'Backspace') {
            userInput = userInput.slice(0, -1);
            render();
        } else if (e.key === 'Enter') {
            checkAnswer();
        } else if (e.key.length === 1 && /[a-zA-Z]/.test(e.key)) {
            if (userInput.length < currentWord.length) {
                userInput += e.key.toUpperCase();
                render();
            }
        }
    });
    
    gameCanvas.addEventListener('click', () => {
        if (gameState === 'ready') startGame();
        if (gameState === 'explaining') nextWord(); // Click to continue reading
        if (gameState === 'ended') restartGame();
    });
}

function showStartScreen() {
    gameState = 'ready';
    
    ctx.fillStyle = '#1a1a2e';
    ctx.fillRect(0, 0, gameCanvas.width, gameCanvas.height);
    
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 48px Fredoka One, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('🌾 Agri-Scramble!', gameCanvas.width / 2, gameCanvas.height / 2 - 80);
    
    ctx.font = '24px Nunito, sans-serif';
    ctx.fillStyle = '#a0a0a0';
    ctx.fillText('Read the hints to unscramble NIR crops!', gameCanvas.width / 2, gameCanvas.height / 2 - 20);
    ctx.fillText('Type your answer and press ENTER', gameCanvas.width / 2, gameCanvas.height / 2 + 20);
    
    ctx.fillStyle = '#4D96FF';
    ctx.font = 'bold 28px Nunito, sans-serif';
    ctx.fillText('Click or Press SPACE to Start', gameCanvas.width / 2, gameCanvas.height / 2 + 100);
    
    ctx.font = '18px Nunito, sans-serif';
    ctx.fillStyle = '#FFD93D';
    ctx.fillText(`Difficulty: ${gameConfig.difficulty.toUpperCase()}`, gameCanvas.width / 2, gameCanvas.height / 2 + 150);
}

function startGame() {
    gameState = 'playing';
    score = 0;
    timeLeft = 60;
    wordsCompleted = 0;
    streak = 0;
    lives = MAX_LIVES;
    level = 1;
    showLevelUpBanner = false;
    usedWords = [];
    userInput = '';
    
    if (typeof playGameSound === 'function') playGameSound('click');
    
    nextWord();
    startTimer();
}

function startTimer() {
    timerInterval = setInterval(() => {
        // ONLY decrement the timer if the user is actively playing. 
        // Timer pauses while reading the explanation!
        if (gameState === 'playing') {
            // Higher levels drain time faster (1 extra 0.5s drain per level above 1)
            const drain = 1 + (level - 1) * 0.5;
            timeLeft = Math.max(0, timeLeft - drain);
            
            if (timeLeft <= 0) {
                endGame();
            } else {
                render();
            }
        }
    }, 1000);
}

function nextWord() {
    gameState = 'playing'; // Resume playing state
    
    // Check for level up
    if (wordsCompleted > 0 && wordsCompleted % WORDS_PER_LEVEL === 0) {
        const newLevel = Math.floor(wordsCompleted / WORDS_PER_LEVEL) + 1;
        if (newLevel > level) {
            level = newLevel;
            showLevelUpBanner = true;
            levelUpBannerTimer = Date.now(); // store start timestamp
            // Bonus life every 2 levels, up to max
            if (level % 2 === 0 && lives < MAX_LIVES) {
                lives++;
            }
            // Animate the banner with requestAnimationFrame
            function animateBanner() {
                if (showLevelUpBanner) {
                    render();
                    requestAnimationFrame(animateBanner);
                }
            }
            requestAnimationFrame(animateBanner);
        }
    }
    const availableWords = words.filter(w => !usedWords.includes(w.word));
    
    if (availableWords.length === 0) {
        usedWords = [];
        availableWords.push(...words);
    }
    
    currentWordObj = availableWords[Math.floor(Math.random() * availableWords.length)];
    currentWord = currentWordObj.word;
    usedWords.push(currentWord);
    scrambledWord = scrambleWord(currentWord);
    userInput = '';
    
    render();
}

function scrambleWord(word) {
    let scrambled = word.split('');
    
    for (let i = scrambled.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [scrambled[i], scrambled[j]] = [scrambled[j], scrambled[i]];
    }
    
    if (scrambled.join('') === word) {
        return scrambleWord(word);
    }
    
    return scrambled.join('');
}

function checkAnswer() {
    if (userInput.toUpperCase() === currentWord.toUpperCase()) {
        // Correct!
        if (typeof playGameSound === 'function') playGameSound('success');
        streak++;
        const basePoints = currentWord.length * 10;
        const streakBonus = streak > 1 ? streak * 5 : 0;
        const timeBonus = Math.floor(timeLeft / 10) * 5;
        const levelMultiplier = level;
        const wordScore = (basePoints + streakBonus + timeBonus) * levelMultiplier;
        
        score += wordScore;
        wordsCompleted++;
        
        // Add bonus time for correct answer
        timeLeft = Math.min(timeLeft + 5, 90);
        
        const scoreElement = document.getElementById('current-score');
        if (scoreElement) {
            scoreElement.textContent = score;
        }
        
        lastWordScore = wordScore;
        
        // Switch to explaining state instead of automatically jumping to next word
        gameState = 'explaining';
        render(); 
    } else {
        // Wrong! Lose a life
        streak = 0;
        lives--;
        if (typeof playGameSound === 'function') playGameSound('fail');
        userInput = '';
        
        if (lives <= 0) {
            endGame();
        } else {
            showFeedback(false, `Wrong! ❤️ ${lives} left`);
            render();
        }
    }
}

function showFeedback(correct, message) {
    render();
    
    ctx.fillStyle = correct ? 'rgba(107, 203, 119, 0.9)' : 'rgba(255, 71, 87, 0.9)';
    ctx.fillRect(gameCanvas.width / 2 - 150, gameCanvas.height / 2 + 80, 300, 60);
    
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 24px Nunito, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText(correct ? '✓ ' + message : '✗ ' + message, gameCanvas.width / 2, gameCanvas.height / 2 + 120);
}

// Helper function to wrap text neatly on the canvas
function wrapText(context, text, x, y, maxWidth, lineHeight) {
    const words = text.split(' ');
    let line = '';

    for (let n = 0; n < words.length; n++) {
        const testLine = line + words[n] + ' ';
        const metrics = context.measureText(testLine);
        const testWidth = metrics.width;
        
        if (testWidth > maxWidth && n > 0) {
            context.fillText(line, x, y);
            line = words[n] + ' ';
            y += lineHeight;
        } else {
            line = testLine;
        }
    }
    context.fillText(line, x, y);
}

// Draw a heart shape at (cx, cy) with given size and fill color
function drawHeart(context, cx, cy, size, color) {
    context.save();
    context.fillStyle = color;
    context.beginPath();
    const s = size;
    context.moveTo(cx, cy + s * 0.3);
    context.bezierCurveTo(cx, cy - s * 0.3, cx - s, cy - s * 0.3, cx - s, cy + s * 0.3);
    context.bezierCurveTo(cx - s, cy + s * 0.8, cx, cy + s * 1.3, cx, cy + s * 1.3);
    context.bezierCurveTo(cx, cy + s * 1.3, cx + s, cy + s * 0.8, cx + s, cy + s * 0.3);
    context.bezierCurveTo(cx + s, cy - s * 0.3, cx, cy - s * 0.3, cx, cy + s * 0.3);
    context.fill();
    context.restore();
}

function render() {
    // 1. Draw Normal Game Background & Elements First
    const gradient = ctx.createLinearGradient(0, 0, 0, gameCanvas.height);
    gradient.addColorStop(0, '#2c3e50');
    gradient.addColorStop(1, '#27ae60'); // Earthy green theme
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, gameCanvas.width, gameCanvas.height);
    
    const timerWidth = (timeLeft / 90) * (gameCanvas.width - 40);
    const timerColor = timeLeft > 20 ? '#6BCB77' : timeLeft > 10 ? '#FFD93D' : '#FF4757';
    
    ctx.fillStyle = 'rgba(255, 255, 255, 0.2)';
    ctx.fillRect(20, 20, gameCanvas.width - 40, 20);
    ctx.fillStyle = timerColor;
    ctx.fillRect(20, 20, timerWidth, 20);
    
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 20px Nunito, sans-serif';
    ctx.textAlign = 'left';
    ctx.fillText(`⏱️ ${Math.ceil(timeLeft)}s`, 20, 65);
    ctx.textAlign = 'center';
    ctx.fillText(`🔥 Streak: ${streak}`, gameCanvas.width / 2, 65);
    ctx.textAlign = 'right';
    ctx.fillText(`📊 Score: ${score}`, gameCanvas.width - 20, 65);
    
    // Level and lives row
    ctx.textAlign = 'left';
    ctx.font = '16px Nunito, sans-serif';
    ctx.fillStyle = '#FFD93D';
    ctx.fillText(`⭐ Lv.${level}`, 20, 90);
    ctx.textAlign = 'center';
    ctx.fillStyle = '#a0a0a0';
    ctx.fillText(`Words: ${wordsCompleted}`, gameCanvas.width / 2, 90);
    
    // Draw lives as canvas heart shapes (emoji is unreliable on canvas)
    const heartSize = 10;
    const heartSpacing = 26;
    const heartsStartX = gameCanvas.width - 20 - (MAX_LIVES - 1) * heartSpacing;
    const heartsY = 82;
    for (let h = 0; h < MAX_LIVES; h++) {
        const hx = heartsStartX + h * heartSpacing;
        const active = h < lives;
        drawHeart(ctx, hx, heartsY, heartSize, active ? '#FF4757' : 'rgba(255,255,255,0.2)');
    }
    
    ctx.font = 'bold 64px Fredoka One, sans-serif';
    ctx.fillStyle = '#FFD93D';
    ctx.textAlign = 'center';
    
    const letterSpacing = 60;
    const startX = gameCanvas.width / 2 - (scrambledWord.length - 1) * letterSpacing / 2;
    
    for (let i = 0; i < scrambledWord.length; i++) {
        const x = startX + i * letterSpacing;
        const y = gameCanvas.height / 2 - 50;
        
        ctx.fillStyle = 'rgba(255, 255, 255, 0.1)';
        ctx.beginPath();
        ctx.roundRect(x - 25, y - 45, 50, 60, 10);
        ctx.fill();
        
        ctx.fillStyle = '#FFD93D';
        ctx.fillText(scrambledWord[i], x, y);
    }
    
    const inputY = gameCanvas.height / 2 + 50;
    const inputStartX = gameCanvas.width / 2 - (currentWord.length - 1) * letterSpacing / 2;
    
    for (let i = 0; i < currentWord.length; i++) {
        const x = inputStartX + i * letterSpacing;
        
        ctx.fillStyle = userInput[i] ? 'rgba(77, 150, 255, 0.3)' : 'rgba(255, 255, 255, 0.1)';
        ctx.strokeStyle = userInput[i] ? '#4D96FF' : 'rgba(255, 255, 255, 0.3)';
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.roundRect(x - 25, inputY - 45, 50, 60, 10);
        ctx.fill();
        ctx.stroke();
        
        if (userInput[i]) {
            ctx.fillStyle = '#ffffff';
            ctx.font = 'bold 48px Fredoka One, sans-serif';
            ctx.fillText(userInput[i], x, inputY);
        }
    }
    
    ctx.font = 'bold 20px Nunito, sans-serif';
    ctx.fillStyle = '#FFD93D'; 
    ctx.fillText(`Hint: ${currentWordObj.hint}`, gameCanvas.width / 2, gameCanvas.height - 80);

    ctx.font = '16px Nunito, sans-serif';
    ctx.fillStyle = '#e0e0e0';
    ctx.fillText('Type the word and press ENTER', gameCanvas.width / 2, gameCanvas.height - 35);


    // 2. Draw the Educational Explanation Overlay if the word was just solved!
    if (gameState === 'explaining') {
        // Dark translucent overlay over the whole game
        ctx.fillStyle = 'rgba(0, 0, 0, 0.9)'; 
        ctx.fillRect(0, 0, gameCanvas.width, gameCanvas.height);
        
        ctx.fillStyle = '#6BCB77';
        ctx.font = 'bold 48px Fredoka One, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('CORRECT! 🎉', gameCanvas.width / 2, gameCanvas.height / 2 - 120);
        
        ctx.fillStyle = '#FFD93D';
        ctx.font = 'bold 36px Nunito, sans-serif';
        ctx.fillText(`${currentWordObj.word}`, gameCanvas.width / 2, gameCanvas.height / 2 - 50);
        
        ctx.fillStyle = '#a0a0a0';
        ctx.font = 'bold 20px Nunito, sans-serif';
        ctx.fillText(`+${lastWordScore} Points! (x${level} level multiplier)`, gameCanvas.width / 2, gameCanvas.height / 2 - 15);
        
        // Draw the educational explanation using the wrap helper
        ctx.fillStyle = '#ffffff';
        ctx.font = '22px Nunito, sans-serif';
        wrapText(ctx, currentWordObj.explanation, gameCanvas.width / 2, gameCanvas.height / 2 + 50, gameCanvas.width - 80, 32);
        
        // Blinking prompt to continue
        ctx.fillStyle = '#4D96FF';
        ctx.font = 'bold 24px Nunito, sans-serif';
        ctx.fillText('Press ENTER to continue', gameCanvas.width / 2, gameCanvas.height - 50);
    }
    
    // Level-up banner overlay (shown on top of the explaining screen)
    if (showLevelUpBanner) {
        const elapsed = Date.now() - levelUpBannerTimer; // levelUpBannerTimer now stores start timestamp
        const duration = 2500; // ms
        if (elapsed >= duration) {
            showLevelUpBanner = false;
        } else {
            const progress = elapsed / duration;
            const alpha = progress < 0.8 ? 1 : 1 - ((progress - 0.8) / 0.2); // fade out last 20%
            ctx.save();
            ctx.globalAlpha = alpha;
            const bh = 110;
            const bw = Math.min(420, gameCanvas.width - 40);
            const bx = gameCanvas.width / 2 - bw / 2;
            const by = gameCanvas.height / 2 - bh / 2 - 60;
            ctx.fillStyle = '#FFD93D';
            ctx.beginPath();
            ctx.roundRect(bx, by, bw, bh, 16);
            ctx.fill();
            ctx.fillStyle = '#1a1a2e';
            ctx.font = 'bold 42px Fredoka One, sans-serif';
            ctx.textAlign = 'center';
            ctx.fillText(`⭐ LEVEL ${level}! ⭐`, gameCanvas.width / 2, by + 58);
            ctx.font = 'bold 17px Nunito, sans-serif';
            ctx.fillText(`Score x${level} multiplier!  Timer drains faster!`, gameCanvas.width / 2, by + 90);
            ctx.restore();
        }
    }
}

function endGame() {
    gameState = 'ended';
    if (typeof playGameSound === 'function') playGameSound('gameover');
    clearInterval(timerInterval);
    
    submitScore(score, {
        words_completed: wordsCompleted,
        highest_streak: streak,
        difficulty: gameConfig.difficulty
    }).then(result => {
        ctx.fillStyle = 'rgba(0, 0, 0, 0.85)';
        ctx.fillRect(0, 0, gameCanvas.width, gameCanvas.height);
        
        ctx.fillStyle = '#ffffff';
        ctx.font = 'bold 48px Fredoka One, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText(lives <= 0 ? '💔 NO LIVES LEFT!' : '⏰ TIME\'S UP!', gameCanvas.width / 2, gameCanvas.height / 2 - 100);
        
        ctx.font = 'bold 36px Nunito, sans-serif';
        ctx.fillStyle = '#FFD93D';
        ctx.fillText(`Final Score: ${score}`, gameCanvas.width / 2, gameCanvas.height / 2 - 30);
        
        ctx.font = '24px Nunito, sans-serif';
        ctx.fillStyle = '#a0a0a0';
        ctx.fillText(`Words Completed: ${wordsCompleted}`, gameCanvas.width / 2, gameCanvas.height / 2 + 20);
        ctx.fillStyle = '#FFD93D';
        ctx.fillText(`Level Reached: ${level}`, gameCanvas.width / 2, gameCanvas.height / 2 + 55);
        
        if (result.success && result.data.points_earned > 0) {
            ctx.fillStyle = '#6BCB77';
            ctx.fillText(`+${result.data.points_earned} Points Earned!`, gameCanvas.width / 2, gameCanvas.height / 2 + 95);
        }
        
        ctx.fillStyle = '#4D96FF';
        ctx.font = 'bold 24px Nunito, sans-serif';
        ctx.fillText('Click to Play Again', gameCanvas.width / 2, gameCanvas.height / 2 + 140);
    });
}

function restartGame() {
    location.reload();
}

window.restartGame = restartGame;