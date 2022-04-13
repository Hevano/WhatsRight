//
//  Copyright © Borna Noureddin. All rights reserved.
//

import GLKit    // use GLKit to treat the iOS display as one that can receive GL draw commands
import AVFoundation

var player: AVAudioPlayer?
var bgMusic: AVAudioPlayer?

func playSound() {
    guard let url = Bundle.main.url(forResource: "ShipMove", withExtension: ".wav") else { return }
    
    do {
        player = try AVAudioPlayer(contentsOf: url)
        player?.play()
    } catch let error {
        print("Error playing sound. \(error.localizedDescription)")
    }
}

func playSoundHit() {
    guard let url = Bundle.main.url(forResource: "ShipHit", withExtension: ".mp3") else { return }
    
    do {
        player = try AVAudioPlayer(contentsOf: url)
        player?.play()
    } catch let error {
        print("Error playing sound. \(error.localizedDescription)")
    }
}

func playSoundBG() {
    guard let url = Bundle.main.url(forResource: "BGMusic", withExtension: ".wav") else { return }
    
    do {
        bgMusic = try AVAudioPlayer(contentsOf: url)
        bgMusic?.prepareToPlay()
        bgMusic?.numberOfLoops = -1
        bgMusic?.play()
    } catch let error {
        print("Error playing sound. \(error.localizedDescription)")
    }
}

// This enables using the GLKit update method to call our own update
extension ViewController: GLKViewControllerDelegate {
    func glkViewControllerUpdate(_ controller: GLKViewController) {
        glesRenderer.update();
        
    }
}

class ViewController: GLKViewController {
    private var context: EAGLContext?       // EAGL context for GL draw commands
    private var glesRenderer: Renderer!     // our own C++ GLES renderer object
    private var button : UIButton!
    private var restartButton : UIButton!
    private var scoreLabel : UILabel!
    private var transformLabel : UILabel!
    private var highscoreLabel : UILabel!
    
    private func setupGL() {
        // Set up the GL context and initialize and setup our GLES renderer object
        context = EAGLContext(api: .openGLES3)
        EAGLContext.setCurrent(context)
        if let view = self.view as? GLKView, let context = context {
            view.context = context
            delegate = self as GLKViewControllerDelegate
            glesRenderer = Renderer()
            glesRenderer.setup(view)
            glesRenderer.loadModels()
        }
    }
    
    override func viewDidLoad() {
        // This gets called as soon as the view is loaded
        super.viewDidLoad()
        playSoundBG()
        
        
        setupGL()   // call this to set up our GL environment
        //playSoundBG()
        // set up swipe gestures
        let SwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.doSwipeUp))
        SwipeUp.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(SwipeUp)
        
        let SwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.doSwipeDown))
        SwipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(SwipeDown)
        
        //Set up Pause button
        button = UIButton(type: .system)
        button.frame = CGRect(x: 450, y: 250, width: 100, height: 50);
        button.setTitle("Pause", for: .normal);
        button.isEnabled = true;
        self.view.addSubview(button);

        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside);
        
        // retrieve score
        
        //Set up reset button
        restartButton = UIButton(type: .system)
        restartButton.frame = CGRect(x: 200, y: 120, width: 200, height: 100);
        //restartButton.backgroundColor = .white;
        restartButton.setTitle("Restart", for: .normal);
        restartButton.isEnabled = false;
        restartButton.isHidden = true;
        restartButton.titleLabel?.font = UIFont(name: "Arial", size: 50);
        //restartButton.titleLabel?.textColor = .black;
        self.view.addSubview(restartButton);

        restartButton.addTarget(self, action: #selector(buttonClickedRestart), for: .touchUpInside);
        
        
        //Set up score label
        scoreLabel = UILabel();
        scoreLabel.text = "Score: " + glesRenderer.score.description;
        scoreLabel.frame = CGRect(x: 300, y: 10, width: 300, height: 50);
        scoreLabel.textAlignment = .center;
        scoreLabel.isEnabled = true;
        scoreLabel.textColor = .white;
        scoreLabel.numberOfLines = 1;
        self.view.addSubview(scoreLabel);
        
        highscoreLabel = UILabel();
        highscoreLabel.text = "High Score: " + glesRenderer.highScore.description;
        highscoreLabel.frame = CGRect(x: -50, y: 10, width: 300, height: 50);
        highscoreLabel.textAlignment = .center;
        highscoreLabel.isEnabled = true;
        highscoreLabel.textColor = .white;
        self.view.addSubview(highscoreLabel);
        
        UserDefaults.standard.set(glesRenderer.highScore, forKey: "score")
        
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glesRenderer.draw(rect);    // use our custom GLES renderer object to make the actual GL draw calls
        //glesRenderer.score = glesRenderer.score + 1;
        scoreLabel.text = "Score: " + glesRenderer.score.description;
        highscoreLabel.text = "High Score: "+UserDefaults.standard.string(forKey: "score")!;
        if (glesRenderer.youLost == true) {
            print("YOU Lost");
            if (UserDefaults.standard.integer(forKey: "score") < glesRenderer.highScore)
            {
                UserDefaults.standard.set(String(glesRenderer.highScore), forKey: "score");
            }
                
            
            restartButton.isEnabled = true;
            restartButton.isHidden = false;
            glesRenderer.youLost = false;
        }
        
        if (glesRenderer.playHitSound == true) {
            glesRenderer.playHitSound = false;
            playSoundHit();
        }
    }
    
    @objc func buttonClicked(_ sender: Any){
    
        glesRenderer.pauseGame = !glesRenderer.pauseGame;
    }
    
    @objc func buttonClickedRestart(_ sender: Any) {
        restartButton.isHidden = true;
        restartButton.isEnabled = false;
        glesRenderer.pauseGame = false;
        glesRenderer.transObstacle = -15;
        
    }

    
    @objc func doSwipeUp(_ sender: UISwipeGestureRecognizer) {
        if(glesRenderer.pauseGame == false){
            if(glesRenderer.position.y >= 1){
                return
            } else {
                glesRenderer.position.y += 1;
                print("Swipe Active");
                print(glesRenderer.position.y);
                playSound();
            }
        }
    }
    
    @objc func doSwipeDown(_ sender: UISwipeGestureRecognizer) {
        if(glesRenderer.pauseGame == false){        if(glesRenderer.position.y <= -1){
                return
            } else {
                //glesRenderer.transX += 1;
                glesRenderer.position.y -= 1;
                print("Swipe Active");
                print(glesRenderer.position.y)
                playSound();
            }
        }
    }
    
    
    
}
