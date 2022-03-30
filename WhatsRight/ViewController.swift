//
//  Copyright © Borna Noureddin. All rights reserved.
//

import GLKit    // use GLKit to treat the iOS display as one that can receive GL draw commands

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
    private var scoreLabel : UILabel!
    private var transformLabel : UILabel!
    
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
        setupGL()   // call this to set up our GL environment
        
        // set up swipe gestures
        let SwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.doSwipeUp))
        SwipeUp.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(SwipeUp)
        
        let SwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.doSwipeDown))
        SwipeDown.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(SwipeDown)
        // Set up a double-tap gesture reognizer
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2;
        view.addGestureRecognizer(doubleTap);
        
        //Set up the drag gesture
//        let drag = UIPanGestureRecognizer(target: self, action: #selector(self.doDrag(_:)))
//        drag.maximumNumberOfTouches = 1;
//        view.addGestureRecognizer(drag);
        
        
        //Set up ping gesture
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.doPinch(_:)));
        view.addGestureRecognizer(pinch);
        
        //Set up
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.doPan(_:)))
        pan.minimumNumberOfTouches = 2;
        view.addGestureRecognizer(pan);
        
        //Set up reset button
//        button = UIButton(type: .system)
//        button.frame = CGRect(x: 200, y: 100, width: 100, height: 50);
//        button.backgroundColor = .green;
//        button.setTitle("Reset", for: .normal);
//        button.isEnabled = true;
//        self.view.addSubview(button);
//
//        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside);
        
        //Set up score label
        scoreLabel = UILabel();
        scoreLabel.text = "Score: " + glesRenderer.score.description;
        scoreLabel.frame = CGRect(x: 0, y: 75, width: 300, height: 50);
        scoreLabel.textAlignment = .center;
        scoreLabel.isEnabled = true;
        scoreLabel.textColor = .white;
        scoreLabel.numberOfLines = 1;
        self.view.addSubview(scoreLabel);
        
        //Set up transform label
        transformLabel = UILabel();
        //transformLabel.text = "" + glesRenderer.rotAngle.description;
        transformLabel.frame = CGRect(x: 0, y: 175, width: 300, height: 50);
        transformLabel.textAlignment = .center;
        transformLabel.isEnabled = true;
        transformLabel.textColor = .green;
        //transformLabel.clipsToBounds = false;
        transformLabel.numberOfLines = 2;
        self.view.addSubview(transformLabel);
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glesRenderer.draw(rect);    // use our custom GLES renderer object to make the actual GL draw calls
        glesRenderer.score = glesRenderer.score + 1;
        scoreLabel.text = "Score: " + glesRenderer.score.description;
//        transformLabel.text = String(format: "Rotation: %.2f, %.2f, %.2f", glesRenderer.panRotation.x, glesRenderer.rotAngle.description, glesRenderer.panRotation.y.description);
//        transformLabel.text! += " \n Position: " + glesRenderer.position.x.description + ", "
//        transformLabel.text! += glesRenderer.position.y.description + ", 0" + glesRenderer.zoom.description;
    }
    
    @objc func doDoubleTap(_ sender: UITapGestureRecognizer) {
        // Handle double tap gesture
        //glesRenderer.isRed = !glesRenderer.isRed;
        // You can add additional things here, for example to toggle whether a cube auto-rotates
        //glesRenderer.isRotating = !glesRenderer.isRotating;
        glesRenderer.position.x -= 1;
    }
    
    @objc func buttonClicked(_ sender: Any){
        glesRenderer.reset = true;
    }
    
//    @objc func doDrag(_ gestureRecognizer : UIPanGestureRecognizer){
//        if(!glesRenderer.isRotating){
//            let panVelocity = gestureRecognizer.translation(in: self.view);
//            glesRenderer.rotate(Float(panVelocity.y), secondAxis: 0.0, thirdAxis: Float(panVelocity.x));
//        }
//    }
    
    @objc func doPan(_ gestureRecognizer : UIPanGestureRecognizer){
        if(!glesRenderer.isRotating){
            let panTranslate = gestureRecognizer.translation(in: self.view);
            print(panTranslate.debugDescription);
            glesRenderer.translate(Float(panTranslate.x / 200), secondAxis: Float(-panTranslate.y / 200), thirdAxis: 0.0);
        }
    }
    
    @objc func doPinch(_ gestureRecognizer : UIPinchGestureRecognizer){
        if(!glesRenderer.isRotating){
            glesRenderer.zoom += Float(-gestureRecognizer.velocity / 10);
        }
    }
    
    @objc func doSwipeUp(_ sender: UISwipeGestureRecognizer) {
        if(glesRenderer.position.y >= 1){
            return
        } else {
            //glesRenderer.transX += 1;
            glesRenderer.position.y += 1;
            print("Swipe Active");
            print(glesRenderer.position.y)
        }
    }
    
    @objc func doSwipeDown(_ sender: UISwipeGestureRecognizer) {
        if(glesRenderer.position.y <= -1){
            return
        } else {
            //glesRenderer.transX += 1;
            glesRenderer.position.y -= 1;
            print("Swipe Active");
            print(glesRenderer.position.y)
        }
        
    }
    
}
