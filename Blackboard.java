// Environment code for project conecta4.mas2j

import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.GridWorldModel;
import jason.environment.grid.GridWorldView;
import jason.environment.grid.Location;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.util.Random;
import java.util.logging.Logger;

public class Blackboard extends Environment {

    public static final int GSize 			=  8; // grid size
    public static final int STEAKRed  		=  16; // steak red code in grid model
    public static final int STEAKBlue  		=  32; // steak blue code in grid model
    public static final int STEAKGreen  	=  64; // steak green code in grid model
    public static final int STEAKCyan  		= 128; // steak cyan code in grid model
    public static final int STEAKPink	  	= 256; // steak pink code in grid model
    public static final int STEAKGray  		= 512; // steak gray code in grid model

    private Logger logger = Logger.getLogger("crush.mas2j."+Blackboard.class.getName());

    private BlackBoardModel model;
    private BlackBoardView  view;
    
    /** Called before the MAS execution with the args informed in .mas2j */
    @Override
    public void init(String[] args) {
        model = new BlackBoardModel();
        view  = new BlackBoardView(model);
        model.setView(view);
        updatePercepts();
        super.init(args);
        //addPercept(Literal.parseLiteral("percept(demo)"));
        Literal size = Literal.parseLiteral("size(" + GSize + ")");
		addPercept(size);		
    }

    @Override
    public boolean executeAction(String ag, Structure action) {
        logger.info(ag+" doing: "+ action);
        try {
            if (ag.equals("judge")) {
				if (action.getFunctor().equals("changetoR")) {
					int x = (int)((NumberTerm)action.getTerm(0)).solve();
					int y = (int)((NumberTerm)action.getTerm(1)).solve();
					model.change(x,y);
				} else if (action.getFunctor().equals("changetoB")) {
					int x = (int)((NumberTerm)action.getTerm(0)).solve();
					int y = (int)((NumberTerm)action.getTerm(1)).solve();
					model.changeB(x,y);
				} else if (action.getFunctor().equals("put")) {
					int color = (int)((NumberTerm)action.getTerm(0)).solve();
					int x = (int)((NumberTerm)action.getTerm(1)).solve();
					model.put(color, x);
				} else if (action.getFunctor().equals("putB")) {
					int x = (int)((NumberTerm)action.getTerm(0)).solve();
					model.putB(x);
				} else {
					return false;
				}
			} else {
				logger.info("Recibido un intento de movimiento ilegal. "+ag+" no puede realizar la acción: "+ action);
				Literal ilegal = Literal.parseLiteral("trampa(" + ag + ")");
				addPercept("judge",ilegal);
			}
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        updatePercepts();

        try {
            Thread.sleep(200);
        } catch (Exception e) {}
        informAgsEnvironmentChanged();
        return true;
    }

    /** creates the agents perception based on the MarsModel */
    void updatePercepts() {
        //clearPercepts();
        Location r1Loc = model.getAgPos(0);
        
        Literal pos1 = Literal.parseLiteral("pos(r1," + r1Loc.x + "," + r1Loc.y + ")");
        
        addPercept(pos1);
		
		//removePerceptsByUnif(Literal.parseLiteral("steak("+16+","+9+","+15+")"));
        
    }

    class BlackBoardModel extends GridWorldModel {
        
        Random random = new Random(System.currentTimeMillis());

        private BlackBoardModel() {
            super(GSize, GSize, 2);
            
            // initial location of agents
            try {
                setAgPos(0, 0, GSize-1);
            
            } catch (Exception e) {
                e.printStackTrace();
            }
            
        }
        
        void moveTowards(int x, int y) throws Exception {
            Location r1 = getAgPos(0);
			r1.x = r1.x + x - 1;
			r1.y = r1.y + y;
			if (r1.x < x)
                r1.x++;
            else if (r1.x > x)
                r1.x--;
            if (r1.y < y)
                r1.y++;
            else if (r1.y > y)
                r1.y--;
            //setAgPos(0, r1);
            //setAgPos(1, getAgPos(1)); // just to draw it in the view
        }

        void put(int x) throws Exception {
            Location r1 = new Location(0,0);
			r1.x = x - 1;
			r1.y = GSize - 1;
            while (hasObject(STEAKRed,r1) || hasObject(STEAKBlue,r1)) r1.y--;
			//if (isFree(r1.x, r1.y)==false) r1.y--;
			//setAgPos(0, r1);
			add(STEAKRed,r1);
            //setAgPos(1, getAgPos(1)); // just to draw it in the view
			Literal newSteak = Literal.parseLiteral("steak(" + STEAKRed + "," + r1.x + "," + r1.y + ")");
        
            addPercept(newSteak);
        }
        
        void putB(int x) throws Exception {
            Location r1 = new Location(0,0);
			r1.x = x - 1;
			r1.y = GSize - 1;
            while (hasObject(STEAKRed,r1) || hasObject(STEAKBlue,r1)) r1.y--;
			//if (isFree(r1.x, r1.y)==false) r1.y--;
			//setAgPos(0, r1);
			add(STEAKBlue,r1);
            //setAgPos(1, getAgPos(1)); // just to draw it in the view
			Literal newSteak = Literal.parseLiteral("steak(" + STEAKBlue + "," + r1.x + "," + r1.y + ")");
        
            addPercept(newSteak);
        }

        void put(int color, int x) throws Exception {
			int y = GSize - 1;
			while ( hasObject(STEAKRed,x,y) || hasObject(STEAKBlue,x,y) ||
					hasObject(STEAKGreen,x,y) || hasObject(STEAKCyan,x,y) ||
			        hasObject(STEAKPink,x,y) || hasObject(STEAKGray,x,y)) y--;
			
            switch (color) {
                case 0: {set(STEAKRed, x, y); 
					     addPercept(Literal.parseLiteral("steak(" + STEAKRed + "," + x + "," + y + ")"));
				        } break;
                case 1: {set(STEAKBlue, x, y); 
					     addPercept(Literal.parseLiteral("steak(" + STEAKBlue + "," + x + "," + y + ")"));
				        }   break;
                case 2: {set(STEAKGreen, x, y); 
					     addPercept(Literal.parseLiteral("steak(" + STEAKGreen + "," + x + "," + y + ")"));
				        }   break;
                case 3: {set(STEAKCyan, x, y); 
					     addPercept(Literal.parseLiteral("steak(" + STEAKCyan + "," + x + "," + y + ")"));
				        }  break;
                case 4: {set(STEAKPink, x, y); 
					     addPercept(Literal.parseLiteral("steak(" + STEAKPink + "," + x + "," + y + ")"));
				        }   break;
                case 5: {set(STEAKGray, x, y); 
					     addPercept(Literal.parseLiteral("steak(" + STEAKGray + "," + x + "," + y + ")"));
				        }   break;
            }

        }
        
        void change(int x, int y) throws Exception {
            /*Location r1 = new Location(0,0);
			r1.x = x;
			r1.y = y;
			remove(STEAKB,r1);
			add(STEAK,r1);
            //setAgPos(1, getAgPos(1)); // just to draw it in the view*/
			set(STEAKRed,x,y);
			Literal oldSteak = Literal.parseLiteral("steak(" + STEAKBlue + "," + x + "," + y + ")");
			Literal newSteak = Literal.parseLiteral("steak(" + STEAKRed + "," + x + "," + y + ")");
			removePercept(oldSteak);
            addPercept(newSteak);
        }
        
        void changeB(int x, int y) throws Exception {
            /*Location r1 = new Location(0,0);
			r1.x = x;
			r1.y = y;
			remove(STEAK,r1);
			add(STEAKB,r1);
            //setAgPos(1, getAgPos(1)); // just to draw it in the view*/
			set(STEAKBlue,x,y);
			Literal oldSteak = Literal.parseLiteral("steak(" + STEAKRed + "," + x + "," + y + ")");
			Literal newSteak = Literal.parseLiteral("steak(" + STEAKBlue + "," + x + "," + y + ")");
			removePercept(oldSteak);
            addPercept(newSteak);
        }
        
    }
    
    class BlackBoardView extends GridWorldView {

        public BlackBoardView(BlackBoardModel model) {
            super(model, "BlackBoard", 500);
            defaultFont = new Font("Arial", Font.BOLD, 12); // change default font
            setVisible(true);
            //repaint();
        }

        /** draw application objects */
        @Override
        public void draw(Graphics g, int x, int y, int object) {
            switch (object) {
                case Blackboard.STEAKRed: drawSTEAK(g, x, y, Color.red);  break;
                case Blackboard.STEAKBlue: drawSTEAK(g, x, y, Color.blue);  break;
                case Blackboard.STEAKGreen: drawSTEAK(g, x, y, Color.green);  break;
                case Blackboard.STEAKCyan: drawSTEAK(g, x, y, Color.cyan);  break;
                case Blackboard.STEAKPink: drawSTEAK(g, x, y, Color.pink);  break;
                case Blackboard.STEAKGray: drawSTEAK(g, x, y, Color.orange);  break;
            }
        }

        @Override
        public void drawAgent(Graphics g, int x, int y, Color c, int id) {
            c = Color.white;
			//g.setColor(c);
			//drawGarb(g, x, y);
			//String label = "R"+(id+1);
            //c = Color.cyan;
            //super.drawAgent(g, x, y, c, -1);
			//drawGarb(g, x, y);
		}
		
		public void drawSTEAK(Graphics g, int x, int y, Color c) {
			g.setColor(c);
			g.fillOval(x * cellSizeW + 2, y * cellSizeH + 2, cellSizeW - 4, cellSizeH - 4);
		}

        public void drawGarb(Graphics g, int x, int y) {
            super.drawObstacle(g, x, y);
            g.setColor(Color.blue);
            drawString(g, x, y, defaultFont, "G");
        }

    }    

    /** Called before the end of MAS execution */
    @Override
    public void stop() {
        super.stop();
    }
}

