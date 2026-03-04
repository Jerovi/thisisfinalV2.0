/**
 * NIR Agri-Quiz Game
 * Answer trivia questions about Negros Island Region agriculture!
 * Features a Leveling System and Health/Lives.
 */

let gameCanvas, ctx;
let gameState = 'ready'; // ready, playing, levelup, ended
let score = 0;
let lives = 3;
let level = 1;
let currentQuestionIndex = 0;
let questionsAnsweredInLevel = 0;
let timeLeft = 15;
let correctAnswers = 0;
let gameConfig;
let timerInterval;
let selectedAnswer = null;
let showingResult = false;

// NIR Agriculture & Production Questions Grouped by Difficulty
const questionBank = {
    easy: [
        { question: "Which crop makes Negros the 'Sugarbowl of the Philippines'?", options: ["Corn", "Rice", "Sugarcane", "Coconut"], correct: 2, category: "Agriculture" },
        { question: "What animal is commonly raised in local backyards for its pork?", options: ["Cow", "Goat", "Pig (Swine)", "Sheep"], correct: 2, category: "Livestock" },
        { question: "What staple grain is primarily grown in the irrigated flatlands of the region?", options: ["Wheat", "Rice", "Oats", "Barley"], correct: 1, category: "Agriculture" },
        { question: "What sweet tropical fruit from Guimaras and Negros is heavily exported?", options: ["Papaya", "Mango", "Durian", "Lanzones"], correct: 1, category: "Production" },
        { question: "Bangus is heavily farmed in coastal aquaculture. What is its English name?", options: ["Milkfish", "Tilapia", "Catfish", "Salmon"], correct: 0, category: "Aquaculture" },
        { question: "What is the primary commercial product extracted from sugarcane?", options: ["Flour", "Salt", "Sugar", "Vinegar"], correct: 2, category: "Production" },
        { question: "What farm animal is raised in large poultry houses for eggs and meat?", options: ["Duck", "Quail", "Turkey", "Chicken"], correct: 3, category: "Livestock" },

        { question: "What traditional work animal is known as the farmer's best friend in the Philippines?", options: ["Horse", "Carabao", "Cow", "Goat"], correct: 1, category: "Livestock" },
        { question: "What is the unmilled form of rice commonly dried on the sides of local highways?", options: ["Palay", "Bigas", "Kanin", "Mais"], correct: 0, category: "Agriculture" },
        { question: "What tall, woody grass is widely used in Negros to build traditional farm huts?", options: ["Rattan", "Mahogany", "Bamboo", "Narra"], correct: 2, category: "Agriculture" },
        { question: "What small, green citrus fruit is squeezed over Chicken Inasal?", options: ["Lemon", "Pomelo", "Orange", "Calamansi"], correct: 3, category: "Agriculture" },
        { question: "What popular local dessert is made using Saba bananas coated in brown sugar and fried?", options: ["Halo-halo", "Turon", "Bibingka", "Puto"], correct: 1, category: "Culture" },
        { question: "In rural areas, what is the most common agricultural use for empty coconut shells?", options: ["Charcoal", "Glass making", "Fertilizer", "Animal feed"], correct: 0, category: "Production" },
        { question: "What natural resource provides the essential energy for sugarcane to grow?", options: ["Wind", "Soil", "Rain", "Sun"], correct: 3, category: "Science" },
        { question: "What starchy root crop is locally known as 'Kamote'?", options: ["Potato", "Sweet Potato", "Cassava", "Taro"], correct: 1, category: "Agriculture" },
        { question: "What farm tool is traditionally pulled by a carabao to turn the soil?", options: ["Tractor", "Scythe", "Plow (Arado)", "Hoe"], correct: 2, category: "Culture" },
        { question: "What is the term for a large farm dedicated to growing fruit trees?", options: ["Orchard", "Vineyard", "Pasture", "Pond"], correct: 0, category: "Agriculture" },
        { question: "What edible fungus is often cultivated on agricultural waste like rice straw?", options: ["Moss", "Seaweed", "Mushroom", "Algae"], correct: 2, category: "Agriculture" },
        { question: "Which of these is a common freshwater fish raised in inland Negros ponds?", options: ["Tuna", "Tilapia", "Shark", "Marlin"], correct: 1, category: "Aquaculture" },
        { question: "What type of farming focuses on raising bees for honey?", options: ["Aquaculture", "Aviculture", "Apiculture", "Floriculture"], correct: 2, category: "Agriculture" },
        { question: "What common vegetable is locally known as 'Kalabasa'?", options: ["Eggplant", "Squash", "Cabbage", "Carrot"], correct: 1, category: "Agriculture" },
        { question: "What poultry bird is primarily raised to produce balut and salted eggs?", options: ["Duck", "Chicken", "Ostrich", "Turkey"], correct: 0, category: "Livestock" },
        { question: "What part of the sugarcane plant is actually processed to get sugar?", options: ["Leaves", "Roots", "Flowers", "Stalk"], correct: 3, category: "Science" },
        { question: "What is the general term for unwanted plants that compete with crops for nutrients?", options: ["Herbs", "Weeds", "Shrubs", "Vines"], correct: 1, category: "Agriculture" },
        { question: "What basic ingredient for local chocolate is harvested from tree pods?", options: ["Coffee", "Vanilla", "Cacao", "Peanut"], correct: 2, category: "Production" },
        { question: "What is the general term for substances added to soil to help plants grow?", options: ["Pesticide", "Herbicide", "Fertilizer", "Fungicide"], correct: 2, category: "Science" },
        { question: "What local fruit has a pungent smell but a sweet, custard-like flesh?", options: ["Mango", "Durian", "Papaya", "Jackfruit"], correct: 1, category: "Agriculture" },
        { question: "What is the main purpose of an irrigation system?", options: ["Pest control", "Watering crops", "Harvesting", "Planting seeds"], correct: 1, category: "Agriculture" },
        { question: "What common farm animal is known as a 'kanding' in the local dialect?", options: ["Pig", "Dog", "Goat", "Cow"], correct: 2, category: "Livestock" },
        { question: "Which part of the banana plant is often used locally as an eco-friendly food wrapper?", options: ["Root", "Stem", "Leaf", "Flower"], correct: 2, category: "Culture" },
        { question: "What is the term for gathering ripe crops from the fields?", options: ["Planting", "Plowing", "Harvesting", "Weeding"], correct: 2, category: "Agriculture" },
        { question: "What agricultural product is ground up to make flour for bread?", options: ["Corn", "Wheat", "Rice", "Sugarcane"], correct: 1, category: "Production" },
        { question: "What small, spicy crop is heavily used in local dishes like sisig and kinilaw?", options: ["Bell Pepper", "Black Pepper", "Chili (Sili)", "Garlic"], correct: 2, category: "Agriculture" },
        { question: "What local root crop, known as 'Ube', is famously used in purple desserts?", options: ["Taro", "Purple Yam", "Cassava", "Radish"], correct: 1, category: "Production" },
        { question: "What is the primary food source for cattle and carabaos on a farm?", options: ["Meat", "Fish", "Grass", "Insects"], correct: 2, category: "Livestock" },
        { question: "What fast-growing tree is often planted in Negros to produce paper and timber?", options: ["Mahogany", "Gmelina", "Mango", "Coconut"], correct: 1, category: "Agriculture" },
        { question: "What insect is essential for pollinating many fruit-bearing crops in the region?", options: ["Mosquito", "Termite", "Bee", "Ant"], correct: 2, category: "Science" }
    ],
    medium: [
        { question: "What sweet local flatbread is primarily made using muscovado sugar?", options: ["Pandesal", "Piaya", "Ensaymada", "Hopia"], correct: 1, category: "Production" },
        { question: "Which elevated NIR city is heavily known for its vegetable terraces?", options: ["Bacolod", "Dumaguete", "Canlaon", "Sipalay"], correct: 2, category: "Geography" },
        { question: "Copra is the dried meat of which widely grown agricultural product?", options: ["Mango", "Cacao", "Coconut", "Papaya"], correct: 2, category: "Agriculture" },
        { question: "What raw material grown in local farms is fermented and processed into Tablea?", options: ["Coffee Beans", "Sugarcane", "Cacao Pods", "Cassava"], correct: 2, category: "Production" },
        { question: "What farming method avoids synthetic pesticides and is heavily championed in Negros?", options: ["Hydroponics", "Slash-and-burn", "Organic Farming", "Monoculture"], correct: 2, category: "Science" },
        { question: "Saba is a widely grown local variety of which fruit used for Turon?", options: ["Mango", "Banana", "Pineapple", "Guava"], correct: 1, category: "Agriculture" },
        { question: "Which city is known as the 'Rice Granary of Negros Occidental'?", options: ["Bago City", "Kabankalan", "Victorias", "Silay"], correct: 0, category: "Geography" },
        { question: "What sour native fruit is the essential flavoring ingredient for the Negrense soup called 'Kansi'?", options: ["Tamarind", "Batuan", "Kamias", "Calamansi"], correct: 1, category: "Culture" },
        { question: "What is the local term for the sun-dried fish that is a staple industry in coastal towns?", options: ["Kinilaw", "Paksiw", "Bulad (Daing)", "Tinapa"], correct: 2, category: "Production" },
        { question: "Which local root crop is highly drought-resistant and can be processed into tapioca?", options: ["Taro", "Sweet Potato", "Cassava", "Yam"], correct: 2, category: "Agriculture" },
        { question: "What is the term for planting different crops in the same area across different seasons to improve soil health?", options: ["Monoculture", "Crop Rotation", "Terracing", "Hydroponics"], correct: 1, category: "Science" },
        { question: "Which Negros Oriental municipality is highly recognized for its extensive geothermal power that aids local agro-industries?", options: ["Sibulan", "Valencia", "Zamboanguita", "Dauin"], correct: 1, category: "Geography" },
        { question: "What is the process of removing the outer husk from rice grains called?", options: ["Milling", "Reaping", "Threshing", "Winnowing"], correct: 0, category: "Production" },
        { question: "What type of local chicken is specifically sought after for making authentic Chicken Inasal?", options: ["Broiler", "Leghorn", "Native Chicken", "Cull"], correct: 2, category: "Livestock" },
        { question: "What popular edible green leafy vegetable, known locally as 'Kangkong', thrives in watery environments?", options: ["Spinach", "Water Spinach", "Bok Choy", "Cabbage"], correct: 1, category: "Agriculture" },
        { question: "In agriculture, what is 'guano', which is sometimes harvested from local caves?", options: ["Bat Excrement (Fertilizer)", "Stalactite Mineral", "Edible Bird Nest", "Cave Water"], correct: 0, category: "Science" },
        { question: "What is the term for farming aquatic animals like prawns and crabs in controlled environments?", options: ["Mariculture", "Agriculture", "Aquaculture", "Silviculture"], correct: 2, category: "Aquaculture" },
        { question: "What heavy farm vehicle is essential for modernizing the plowing of massive sugar haciendas?", options: ["Bulldozer", "Excavator", "Tractor", "Harvester"], correct: 2, category: "Agriculture" },
        { question: "What local fruit, known as 'Langka', can be eaten sweet when ripe or cooked as a vegetable when green?", options: ["Breadfruit", "Jackfruit", "Durian", "Marang"], correct: 1, category: "Agriculture" },
        { question: "Which Negros city is famously home to the Victorias Milling Company, one of the world's largest integrated sugar mills?", options: ["Silay", "Talisay", "Victorias", "Sagay"], correct: 2, category: "Geography" },
        { question: "What is the primary purpose of a 'Bagsakan' in the local agricultural supply chain?", options: ["A slaughterhouse", "A wholesale trading market", "A pesticide storage", "A farm equipment store"], correct: 1, category: "Culture" },
        { question: "What specific type of coffee bean is most commonly grown in the highlands of Negros due to its hardiness?", options: ["Arabica", "Robusta", "Liberica", "Excelsa"], correct: 1, category: "Agriculture" },
        { question: "What is the local term for the system of sharing the harvest between a landowner and a tenant farmer?", options: ["Pakyaw", "Tapas", "Arkabala", "Sharecropping (Porsiyento)"], correct: 3, category: "Culture" },
        { question: "Which spice, grown in elevated areas, is the rhizome of a plant and heavily used in Tinola?", options: ["Garlic", "Onion", "Ginger", "Turmeric"], correct: 2, category: "Agriculture" },
        { question: "What is the main environmental benefit of planting Mangrove trees along the Negros coastlines?", options: ["Produces sweet fruit", "Protects against soil erosion and waves", "Provides timber for houses", "Kills saltwater pests"], correct: 1, category: "Science" },
        { question: "What type of meat comes from a mature sheep, sometimes raised in local highland pastures?", options: ["Venison", "Veal", "Pork", "Mutton"], correct: 3, category: "Livestock" },
        { question: "What stringy vegetable, locally called 'Sitaw', is a common ingredient in the dish Pinakbet?", options: ["String Bean (Yardlong bean)", "Mung Bean", "Snow Pea", "Soybean"], correct: 0, category: "Agriculture" },
        { question: "What is the term for raising plants without soil, using nutrient-rich water solutions instead?", options: ["Aeroponics", "Hydroponics", "Aquaponics", "Geoponics"], correct: 1, category: "Science" },
        { question: "What large, spiky fruit is known for its strong odor and is increasingly being cultivated in Negros?", options: ["Marang", "Jackfruit", "Rambutan", "Durian"], correct: 3, category: "Agriculture" },
        { question: "What is the main agricultural use of the 'Mudpress', a byproduct of sugar milling?", options: ["Animal feed", "Organic fertilizer", "Aviation fuel", "Building roads"], correct: 1, category: "Production" },
        { question: "What agricultural sector deals specifically with the cultivation and management of forest trees?", options: ["Horticulture", "Agronomy", "Forestry (Silviculture)", "Floriculture"], correct: 2, category: "Agriculture" },
        { question: "What local leaf is famously used to wrap the traditional Negrense delicacy called 'Ibos'?", options: ["Banana Leaf", "Coconut Leaf (Palaspas)", "Pandan Leaf", "Taro Leaf"], correct: 1, category: "Culture" },
        { question: "Which fruit is uniquely associated with the Manggahan Festival of the neighboring island province of Guimaras?", options: ["Pineapple", "Banana", "Mango", "Watermelon"], correct: 2, category: "Culture" },
        { question: "What is the primary function of a greenhouse in highland vegetable farming?", options: ["To keep pests out completely", "To control temperature and humidity", "To store harvested crops", "To block out sunlight"], correct: 1, category: "Science" },
        { question: "What is the term for the mature, dried seeds of legumes like beans and lentils?", options: ["Grains", "Cereals", "Pulses", "Nuts"], correct: 2, category: "Agriculture" },
        { question: "What is the local name for the small, fermented shrimp paste often paired with green mangoes?", options: ["Patis", "Bagoong (Ginamos)", "Toyo", "Suka"], correct: 1, category: "Production" },
        { question: "What type of aquaculture enclosure is placed in open water to farm fish like Tilapia?", options: ["Fish cage", "Aquarium", "Earthen pond", "Concrete tank"], correct: 0, category: "Aquaculture" }
    ],
    hard: [
        { question: "What is the traditional term for large agricultural sugarcane estates in Negros?", options: ["Plantation", "Hacienda", "Ranch", "Orchard"], correct: 1, category: "History" },
        { question: "What is the fibrous residue left after sugarcane stalks are crushed, often used for fuel?", options: ["Bagasse", "Molasses", "Mudpress", "Ash"], correct: 0, category: "Science" },
        { question: "What local harvest season is traditionally referred to as 'Tiempo Suerte'?", options: ["Rice Harvest", "Mango Season", "Sugarcane Harvest", "Fishing Season"], correct: 2, category: "Culture" },
        { question: "Which hardy coffee bean variety thrives in the lower mountain elevations of the region?", options: ["Arabica", "Robusta", "Liberica", "Excelsa"], correct: 1, category: "Agriculture" },
        { question: "What specific agricultural pest bores into the stems of local rice and sugarcane?", options: ["Locust", "Aphid", "Stem Borer", "Weevil"], correct: 2, category: "Science" },
        { question: "What is the term for healthy, unrefined local sugar that retains its natural molasses?", options: ["Refined White", "Muscovado", "Confectioners", "Brown Sugar"], correct: 1, category: "Production" },
        { question: "What byproduct of sugarcane milling is commonly fermented to produce bioethanol?", options: ["Bagasse", "Molasses", "Mudpress", "Juice"], correct: 1, category: "Science" },
        { question: "What is the local Hiligaynon term for the migrant agricultural workers who harvest sugarcane?", options: ["Kargador", "Sacada", "Cabo", "Hacendero"], correct: 1, category: "History" },
        { question: "What is the 'Tiempo Muerto' or 'Dead Season' in the Negros sugar industry?", options: ["When the mills break down", "The period between planting and harvesting", "A season of crop disease", "When the soil loses fertility"], correct: 1, category: "Culture" },
        { question: "Which government agency is primarily responsible for the regulation and development of the sugar industry?", options: ["DENR", "SRA (Sugar Regulatory Administration)", "DAR", "NFA"], correct: 1, category: "History" },
        { question: "What nitrogen-fixing legume is often planted during the off-season to restore soil health in sugar farms?", options: ["Mung Bean (Mongo)", "Peanut", "Corn", "Cassava"], correct: 0, category: "Science" },
        { question: "In sugar milling, what machine uses rapid spinning to separate sugar crystals from molasses?", options: ["Evaporator", "Clarifier", "Centrifuge", "Boiler"], correct: 2, category: "Production" },
        { question: "What scientific value measures the acidity or alkalinity of the region's volcanic soil?", options: ["NPK Ratio", "Soil pH", "Brix Level", "Salinity"], correct: 1, category: "Science" },
        { question: "What is the term for the percentage of sucrose present in the sugarcane juice?", options: ["Brix", "Polarization", "Yield", "Purity"], correct: 0, category: "Science" },
        { question: "What local term refers to the overseer or supervisor of workers in a sugarcane hacienda?", options: ["Encargado / Cabo", "Sacada", "Tapasero", "Pakyaw"], correct: 0, category: "History" },
        { question: "What is the highly destructive viral disease that causes yellowing and stunting in sugarcane leaves?", options: ["Smut", "Sugarcane Mosaic Virus", "Rust", "Leaf Scald"], correct: 1, category: "Science" },
        { question: "Which macro-nutrient is most critical for promoting the rapid vegetative leaf growth of sugarcane?", options: ["Phosphorus", "Potassium", "Nitrogen", "Calcium"], correct: 2, category: "Science" },
        { question: "What is the local term for the manual cutting and harvesting of sugarcane?", options: ["Gapas", "Tapas", "Hakot", "Pugas"], correct: 1, category: "Culture" },
        { question: "In aquaculture, what does 'FCR' stand for, which determines the efficiency of feeding fish?", options: ["Fish Catch Rate", "Feed Conversion Ratio", "Farm Control Record", "Floating Cage Rearing"], correct: 1, category: "Science" },
        { question: "What agrarian reform program in the Philippines aimed to distribute private agricultural lands, including haciendas, to landless farmers?", options: ["TRAIN Law", "CARP (Comprehensive Agrarian Reform Program)", "Build Build Build", "Bayanihan"], correct: 1, category: "History" },
        { question: "What dark, viscous liquid is the final byproduct of sugar refining from which no more sugar can be crystallized?", options: ["Blackstrap Molasses", "Golden Syrup", "Corn Syrup", "Agave Nectar"], correct: 0, category: "Production" },
        { question: "What agricultural practice involves leaving a field unplanted for a season to allow the soil to recover?", options: ["Intercropping", "Fallowing", "Mulching", "Tilling"], correct: 1, category: "Science" },
        { question: "What is the botanical family to which sugarcane (Saccharum officinarum) belongs?", options: ["Fabaceae (Legumes)", "Solanaceae (Nightshades)", "Poaceae (Grasses)", "Rutaceae (Citrus)"], correct: 2, category: "Science" },
        { question: "Which indigenous group in the mountainous regions of Negros has historically practiced traditional swidden (slash-and-burn) agriculture?", options: ["Ati / Bukidnon", "Igorot", "Mangyan", "Badjao"], correct: 0, category: "History" },
        { question: "What is the process of using beneficial insects to manage agricultural pests called?", options: ["Chemical Control", "Biological Control", "Cultural Control", "Mechanical Control"], correct: 1, category: "Science" },
        { question: "What is 'Ratoon cropping', a common practice in Negros sugarcane farming?", options: ["Planting multiple crops together", "Allowing a new crop to grow from the stubble of the harvested crop", "Growing crops in water", "Planting only in the dry season"], correct: 1, category: "Science" },
        { question: "What crucial soil nutrient, often added via fertilizer, promotes strong root development and flower formation?", options: ["Nitrogen", "Potassium", "Phosphorus", "Sulfur"], correct: 2, category: "Science" },
        { question: "What is the term for the artificial removal of excess water from agricultural land to prevent waterlogging?", options: ["Irrigation", "Drainage", "Transpiration", "Percolation"], correct: 1, category: "Science" },
        { question: "What does the 'N-P-K' ratio on a bag of commercial fertilizer stand for?", options: ["Nitrogen-Phosphorus-Potassium", "Nickel-Palladium-Krypton", "Nitrate-Phosphate-Calcium", "Nitrogen-Potash-Kelp"], correct: 0, category: "Science" },
        { question: "What is the term for the young fish or fish seed used to stock an aquaculture pond?", options: ["Fry / Fingerlings", "Tadpoles", "Spawns", "Larvae"], correct: 0, category: "Aquaculture" },
        { question: "What is the highly coveted, expensive coffee made from beans partially digested by a civet cat, sometimes produced in Negros highlands?", options: ["Kopi Luwak (Civet Coffee)", "Macadamia Coffee", "Blue Mountain", "Espresso"], correct: 0, category: "Production" },
        { question: "What is the primary factor that makes the soil around Mt. Kanlaon exceptionally fertile for agriculture?", options: ["High sand content", "Volcanic ash deposits (Andisol)", "High salinity", "Heavy clay composition"], correct: 1, category: "Geography" },
        { question: "What is 'Vermicomposting', a method championed by organic farms in the region?", options: ["Using chemical sprays", "Composting using earthworms", "Burning organic waste", "Using fish waste as fertilizer"], correct: 1, category: "Science" },
        { question: "In the context of local land reform, what does 'ARB' stand for?", options: ["Agricultural Resource Board", "Agrarian Reform Beneficiary", "Association of Rice Breeders", "Annual Revenue Base"], correct: 1, category: "History" },
        { question: "What specific type of tractor attachment is used to deeply break up hardpan soil without turning it over?", options: ["Disc Harrow", "Rotavator", "Subsoiler", "Moldboard Plow"], correct: 2, category: "Science" },
        { question: "What environmental phenomenon, characterized by severe drought, critically threatens Negros agriculture every few years?", options: ["La Niña", "El Niño", "Monsoon", "Typhoon"], correct: 1, category: "Geography" },
        { question: "What is the industrial process of treating milk to destroy pathogenic microbes, utilized by local dairy cooperatives?", options: ["Homogenization", "Fermentation", "Pasteurization", "Distillation"], correct: 2, category: "Production" }
    ]
};

let currentLevelQuestions = [];
let currentQuestion = null;

function initGame(container, config) {
    gameConfig = config;
    
    gameCanvas = document.createElement('canvas');
    gameCanvas.id = 'quiz-master-canvas';
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
    
    if (gameState === 'playing' || gameState === 'levelup') {
        render();
    }
}

function setupInputHandlers() {
    gameCanvas.addEventListener('click', (e) => {
        if (gameState === 'ready') {
            startGame();
            return;
        }
        
        if (gameState === 'ended') {
            restartGame();
            return;
        }
        
        if (gameState === 'playing' && !showingResult) {
            handleClick(e);
        }
    });
    
    // Keyboard shortcuts
    document.addEventListener('keydown', (e) => {
        if (gameState === 'ready' && e.key === ' ') {
            startGame();
            return;
        }
        
        if (gameState === 'playing' && !showingResult) {
            const keyNum = parseInt(e.key);
            if (keyNum >= 1 && keyNum <= 4) {
                selectAnswer(keyNum - 1);
            }
        }
    });
}

function handleClick(e) {
    const rect = gameCanvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    
    // Check if clicked on an answer option
    const optionHeight = 60;
    const optionWidth = gameCanvas.width - 80;
    const startY = gameCanvas.height / 2 - 20;
    
    for (let i = 0; i < 4; i++) {
        const optionY = startY + i * (optionHeight + 15);
        
        if (x >= 40 && x <= 40 + optionWidth &&
            y >= optionY && y <= optionY + optionHeight) {
            selectAnswer(i);
            break;
        }
    }
}

function selectAnswer(index) {
    if (showingResult) return;
    
    selectedAnswer = index;
    showingResult = true;
    clearInterval(timerInterval);
    
    const isCorrect = index === currentQuestion.correct;
    
    if (isCorrect) {
        if (typeof playGameSound === 'function') playGameSound('success');
        const timeBonus = Math.floor(timeLeft * 2);
        const questionScore = (level * 50) + timeBonus; // Higher levels give more base points
        score += questionScore;
        correctAnswers++;
        questionsAnsweredInLevel++;
        
        const scoreElement = document.getElementById('current-score');
        if(scoreElement) scoreElement.textContent = score;
        
    } else {
        lives--; // Wrong answer costs a life
        if (typeof playGameSound === 'function') playGameSound('fail');
    }
    
    render();
    
    // Show result for 1.5 seconds then evaluate next step
    setTimeout(() => {
        showingResult = false;
        selectedAnswer = null;
        
        if (lives <= 0) {
            endGame(false); // Game Over (Lost)
            return;
        }
        
        // Level up condition: 5 correct answers per level
        if (questionsAnsweredInLevel >= 5) {
            if (level === 3) {
                endGame(true); // Game Over (Won!)
            } else {
                levelUp();
            }
        } else {
            currentQuestionIndex++;
            if (currentQuestionIndex >= currentLevelQuestions.length) {
                // Failsafe: if we run out of questions in the array, shuffle and restart array
                currentLevelQuestions = [...currentLevelQuestions].sort(() => Math.random() - 0.5);
                currentQuestionIndex = 0;
            }
            prepareNextQuestion();
        }
    }, 1500);
}

function showStartScreen() {
    gameState = 'ready';
    
    ctx.fillStyle = '#1a1a2e';
    ctx.fillRect(0, 0, gameCanvas.width, gameCanvas.height);
    
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 48px Fredoka One, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText('❓ NIR Agri-Quiz!', gameCanvas.width / 2, gameCanvas.height / 2 - 80);
    
    ctx.font = '24px Nunito, sans-serif';
    ctx.fillStyle = '#a0a0a0';
    ctx.fillText('Test your local farming knowledge!', gameCanvas.width / 2, gameCanvas.height / 2 - 20);
    
    ctx.fillStyle = '#FF4757';
    ctx.fillText('❤️ 3 Lives • 3 Levels', gameCanvas.width / 2, gameCanvas.height / 2 + 20);
    
    ctx.fillStyle = '#4D96FF';
    ctx.font = 'bold 28px Nunito, sans-serif';
    ctx.fillText('Click or Press SPACE to Start', gameCanvas.width / 2, gameCanvas.height / 2 + 100);
}

function startGame() {
    score = 0;
    lives = 3;
    level = 1;
    correctAnswers = 0;
    if (typeof playGameSound === 'function') playGameSound('click');
    loadLevel(level);
}

function loadLevel(lvl) {
    gameState = 'playing';
    questionsAnsweredInLevel = 0;
    currentQuestionIndex = 0;
    
    // Select questions based on level
    let pool = [];
    if (lvl === 1) pool = questionBank.easy;
    else if (lvl === 2) pool = questionBank.medium;
    else pool = questionBank.hard;
    
    // Shuffle the pool for this level
    currentLevelQuestions = [...pool].sort(() => Math.random() - 0.5);
    
    prepareNextQuestion();
}

function prepareNextQuestion() {
    currentQuestion = currentLevelQuestions[currentQuestionIndex];
    showingResult = false;
    
    // Set time limits based on level difficulty
    if (level === 1) timeLeft = 15;
    else if (level === 2) timeLeft = 12;
    else timeLeft = 10;
    
    startTimer();
    render();
}

function levelUp() {
    gameState = 'levelup';
    if (typeof playGameSound === 'function') playGameSound('levelup');
    clearInterval(timerInterval);
    level++;
    
    render(); // Draw the level up screen
    
    setTimeout(() => {
        loadLevel(level);
    }, 2500);
}

function startTimer() {
    clearInterval(timerInterval);
    timerInterval = setInterval(() => {
        timeLeft--;
        
        if (timeLeft <= 0) {
            // Time's up - treat as wrong answer
            clearInterval(timerInterval);
            showingResult = true;
            lives--; // Timeout costs a life
            if (typeof playGameSound === 'function') playGameSound('fail');
            render();
            
            setTimeout(() => {
                showingResult = false;
                
                if (lives <= 0) {
                    endGame(false);
                    return;
                }
                
                currentQuestionIndex++;
                if (currentQuestionIndex >= currentLevelQuestions.length) {
                    currentLevelQuestions = [...currentLevelQuestions].sort(() => Math.random() - 0.5);
                    currentQuestionIndex = 0;
                }
                prepareNextQuestion();
            }, 1500);
        } else {
            render();
        }
    }, 1000);
}

function render() {
    // Level Up Screen Overlay
    if (gameState === 'levelup') {
        ctx.fillStyle = 'rgba(39, 174, 96, 0.9)'; // Green Agri theme
        ctx.fillRect(0, 0, gameCanvas.width, gameCanvas.height);
        
        ctx.fillStyle = '#ffffff';
        ctx.font = 'bold 56px Fredoka One, sans-serif';
        ctx.textAlign = 'center';
        ctx.fillText('LEVEL UP! 🌟', gameCanvas.width / 2, gameCanvas.height / 2 - 20);
        
        ctx.font = 'bold 28px Nunito, sans-serif';
        ctx.fillStyle = '#FFD93D';
        ctx.fillText(`Entering Level ${level}`, gameCanvas.width / 2, gameCanvas.height / 2 + 40);
        
        let msg = level === 2 ? "Questions are harder! Time limit: 12s" : "Maximum Difficulty! Time limit: 10s";
        ctx.font = '20px Nunito, sans-serif';
        ctx.fillStyle = '#ffffff';
        ctx.fillText(msg, gameCanvas.width / 2, gameCanvas.height / 2 + 80);
        return;
    }

    // Normal Gameplay Background
    const gradient = ctx.createLinearGradient(0, 0, 0, gameCanvas.height);
    gradient.addColorStop(0, '#0f0c29');
    gradient.addColorStop(0.5, '#302b63');
    gradient.addColorStop(1, '#24243e');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, gameCanvas.width, gameCanvas.height);
    
    if (!currentQuestion) return;

    // Progress bar for the current level (5 questions per level)
    const progress = questionsAnsweredInLevel / 5;
    ctx.fillStyle = 'rgba(255, 255, 255, 0.1)';
    ctx.fillRect(20, 20, gameCanvas.width - 40, 10);
    ctx.fillStyle = '#6BCB77';
    ctx.fillRect(20, 20, (gameCanvas.width - 40) * progress, 10);
    
    // Stats Header (Level, Lives, Score)
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 18px Nunito, sans-serif';
    ctx.textAlign = 'left';
    ctx.fillText(`Level ${level}`, 20, 55);
    
    ctx.textAlign = 'center';
    ctx.fillText(`Lives: ${'❤️'.repeat(lives)}${'🖤'.repeat(3 - lives)}`, gameCanvas.width / 2, 55);
    
    ctx.textAlign = 'right';
    ctx.fillStyle = '#FFD93D';
    ctx.fillText(`Score: ${score}`, gameCanvas.width - 20, 55);
    
    // Category badge
    ctx.textAlign = 'center';
    ctx.fillStyle = '#27ae60'; // Agricultural green
    ctx.font = 'bold 14px Nunito, sans-serif';
    const categoryWidth = ctx.measureText(currentQuestion.category).width + 20;
    ctx.fillRect(gameCanvas.width / 2 - categoryWidth / 2, 70, categoryWidth, 25);
    ctx.fillStyle = '#ffffff';
    ctx.fillText(currentQuestion.category, gameCanvas.width / 2, 88);
    
    // Timer
    const timerColor = timeLeft > (level === 1 ? 8 : 5) ? '#6BCB77' : timeLeft > 3 ? '#FFD93D' : '#FF4757';
    ctx.fillStyle = timerColor;
    ctx.font = 'bold 36px Nunito, sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText(`⏱️ ${timeLeft}`, gameCanvas.width / 2, 130);
    
    // Question text (Word wrapped)
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 22px Nunito, sans-serif';
    ctx.textAlign = 'center';
    
    const maxWidth = gameCanvas.width - 60;
    const words = currentQuestion.question.split(' ');
    let line = '';
    let y = 180;
    
    for (const word of words) {
        const testLine = line + word + ' ';
        if (ctx.measureText(testLine).width > maxWidth) {
            ctx.fillText(line.trim(), gameCanvas.width / 2, y);
            line = word + ' ';
            y += 32;
        } else {
            line = testLine;
        }
    }
    ctx.fillText(line.trim(), gameCanvas.width / 2, y);
    
    // Answer options
    const optionHeight = 60;
    const optionWidth = gameCanvas.width - 80;
    const startY = gameCanvas.height / 2 - 10;
    
    for (let i = 0; i < currentQuestion.options.length; i++) {
        const optionY = startY + i * (optionHeight + 15);
        
        let bgColor = 'rgba(255, 255, 255, 0.1)';
        let borderColor = 'rgba(255, 255, 255, 0.3)';
        let textColor = '#ffffff';
        
        if (showingResult) {
            if (i === currentQuestion.correct) {
                bgColor = 'rgba(107, 203, 119, 0.8)'; // Green if correct
                borderColor = '#6BCB77';
            } else if (i === selectedAnswer && i !== currentQuestion.correct) {
                bgColor = 'rgba(255, 71, 87, 0.8)'; // Red if selected wrong
                borderColor = '#FF4757';
            }
        } else if (selectedAnswer === i) {
            bgColor = 'rgba(77, 150, 255, 0.5)';
            borderColor = '#4D96FF';
        }
        
        // Option background
        ctx.fillStyle = bgColor;
        ctx.strokeStyle = borderColor;
        ctx.lineWidth = 3;
        ctx.beginPath();
        ctx.roundRect(40, optionY, optionWidth, optionHeight, 15);
        ctx.fill();
        ctx.stroke();
        
        // Option number
        ctx.fillStyle = textColor;
        ctx.font = 'bold 18px Nunito, sans-serif';
        ctx.textAlign = 'left';
        ctx.fillText(`${i + 1}`, 60, optionY + 38);
        
        // Option text
        ctx.font = '18px Nunito, sans-serif';
        ctx.fillText(currentQuestion.options[i], 100, optionY + 38);
    }
    
    // Instructions
    if (!showingResult) {
        ctx.font = '14px Nunito, sans-serif';
        ctx.fillStyle = '#a0a0a0';
        ctx.textAlign = 'center';
        ctx.fillText('Click an option or press 1-4', gameCanvas.width / 2, gameCanvas.height - 20);
    }
}

function endGame(won) {
    gameState = 'ended';
    if (typeof playGameSound === 'function') playGameSound(won ? 'success' : 'gameover');
    clearInterval(timerInterval);
    
    // 5 questions per level * 3 levels max = 15 total possible correct
    let maxPossible = 15; 
    let accuracy = Math.round((correctAnswers / (correctAnswers + (3 - lives))) * 100) || 0;
    
    submitScore(score, {
        correct_answers: correctAnswers,
        level_reached: level,
        accuracy: accuracy
    }).then(result => {
        ctx.fillStyle = 'rgba(0, 0, 0, 0.9)';
        ctx.fillRect(0, 0, gameCanvas.width, gameCanvas.height);
        
        ctx.fillStyle = '#ffffff';
        ctx.font = 'bold 48px Fredoka One, sans-serif';
        ctx.textAlign = 'center';
        
        if (won) {
            ctx.fillStyle = '#FFD93D';
            ctx.fillText('🏆 QUIZ MASTER!', gameCanvas.width / 2, gameCanvas.height / 2 - 100);
        } else {
            ctx.fillStyle = '#FF4757';
            ctx.fillText('💔 GAME OVER', gameCanvas.width / 2, gameCanvas.height / 2 - 100);
        }
        
        ctx.font = 'bold 36px Nunito, sans-serif';
        ctx.fillStyle = '#ffffff';
        ctx.fillText(`Score: ${score}`, gameCanvas.width / 2, gameCanvas.height / 2 - 30);
        
        ctx.font = '24px Nunito, sans-serif';
        ctx.fillStyle = '#a0a0a0';
        ctx.fillText(`Reached Level ${level} • ${correctAnswers} Correct`, gameCanvas.width / 2, gameCanvas.height / 2 + 20);
        
        if (result.success && result.data.points_earned > 0) {
            ctx.fillStyle = '#6BCB77';
            ctx.fillText(`+${result.data.points_earned} Points Earned!`, gameCanvas.width / 2, gameCanvas.height / 2 + 60);
        }
        
        ctx.fillStyle = '#4D96FF';
        ctx.font = 'bold 24px Nunito, sans-serif';
        ctx.fillText('Click to Play Again', gameCanvas.width / 2, gameCanvas.height / 2 + 120);
    });
}

function restartGame() {
    location.reload();
}

window.restartGame = restartGame;