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
    
    private func setupGL() {
        // Set up the GL context and initialize and setup our GLES renderer object
        context = EAGLContext(api: .openGLES3)
        EAGLContext.setCurrent(context)
        if let view = self.view as? GLKView, let context = context {
            view.context = context
            delegate = self as GLKViewControllerDelegate
            glesRenderer = Renderer()
            glesRenderer.setup(view)
        }
    }
    
    override func viewDidLoad() {
        // This gets called as soon as the view is loaded
        super.viewDidLoad()
        setupGL()   // call this to set up our GL environment
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glesRenderer.draw(rect);    // use our custom GLES renderer object to make the actual GL draw calls
    }
}
