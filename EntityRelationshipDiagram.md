# Entity Relationship Diagram (ERD)

## Game System Database Structure

The game system database structure is designed to manage various aspects of the game, including players, quests, items, and interactions. Below is a brief description of the primary entities and their relationships:

### Entities:
1. **Player**  
   - **Attributes:**  
     - PlayerID (Primary Key)  
     - Username  
     - Email  
     - Password  
     - CreatedAt  

2. **Quest**  
   - **Attributes:**  
     - QuestID (Primary Key)  
     - Title  
     - Description  
     - Status  
     - CreatedAt  

3. **Item**  
   - **Attributes:**  
     - ItemID (Primary Key)  
     - ItemName  
     - ItemType  
     - Rarity  
     - CreatedAt  

4. **Interaction**  
   - **Attributes:**  
     - InteractionID (Primary Key)  
     - PlayerID (Foreign Key)  
     - QuestID (Foreign Key)  
     - Action  
     - Timestamp  

### Relationships:
- **Player - Interaction:** One-to-Many  
  A player can have multiple interactions.

- **Quest - Interaction:** One-to-Many  
  A quest can have multiple interactions.

- **Player - Quest:** Many-to-Many  
  Players can participate in multiple quests, and quests can have multiple players involved.