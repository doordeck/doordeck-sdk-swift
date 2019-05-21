//
//  unlockAnimation.swift
//
//  Code generated using QuartzCode 1.63.0 on 21/05/2019.
//  www.quartzcodeapp.com
//

import UIKit

@IBDesignable
class unlockAnimation: UIView, CAAnimationDelegate {
    
    var layers = [String: CALayer]()
    var completionBlocks = [CAAnimation: (Bool) -> Void]()
    var updateLayerValueForCompletedAnimation : Bool = false
    
    var color : UIColor!
    var blue : UIColor!
    var color1 : UIColor!
    var accent : UIColor!
    var success : UIColor!
    var error : UIColor!
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupProperties()
        setupLayers()
    }
    
    override var frame: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    override var bounds: CGRect{
        didSet{
            setupLayerFrames()
        }
    }
    
    func setupProperties(){
        self.color = UIColor(red:0.99, green: 1, blue:1, alpha:1)
        self.blue = UIColor(red:0, green: 0.157, blue:0.235, alpha:1)
        self.color1 = UIColor(red:0.99, green: 1, blue:1, alpha:0)
        self.accent = UIColor(red:0.271, green: 0.741, blue:0.82, alpha:1)
        self.success = UIColor(red:0.2, green: 0.808, blue:0.298, alpha:1)
        self.error = UIColor(red:0.976, green: 0.196, blue:0.318, alpha:1)
    }
    
    func setupLayers(){
        self.backgroundColor = UIColor(red:0, green: 0.21, blue:0.302, alpha:0)
        
        let whitecircle = CAShapeLayer()
        self.layer.addSublayer(whitecircle)
        layers["whitecircle"] = whitecircle
        
        let whitecircle2 = CAShapeLayer()
        self.layer.addSublayer(whitecircle2)
        layers["whitecircle2"] = whitecircle2
        
        let loadingcircle = CAShapeLayer()
        self.layer.addSublayer(loadingcircle)
        layers["loadingcircle"] = loadingcircle
        
        let whitecircle3 = CAShapeLayer()
        self.layer.addSublayer(whitecircle3)
        layers["whitecircle3"] = whitecircle3
        
        let whitecircle4 = CAShapeLayer()
        self.layer.addSublayer(whitecircle4)
        layers["whitecircle4"] = whitecircle4
        
        let tick = CAShapeLayer()
        self.layer.addSublayer(tick)
        layers["tick"] = tick
        
        let lock = CAShapeLayer()
        self.layer.addSublayer(lock)
        layers["lock"] = lock
        
        let arrow = CAShapeLayer()
        self.layer.addSublayer(arrow)
        layers["arrow"] = arrow
        
        let min = CAShapeLayer()
        self.layer.addSublayer(min)
        layers["min"] = min
        
        let min2 = CAShapeLayer()
        self.layer.addSublayer(min2)
        layers["min2"] = min2
        
        resetLayerProperties(forLayerIdentifiers: nil)
        setupLayerFrames()
    }
    
    func resetLayerProperties(forLayerIdentifiers layerIds: [String]!){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if layerIds == nil || layerIds.contains("whitecircle"){
            let whitecircle = layers["whitecircle"] as! CAShapeLayer
            whitecircle.opacity     = 0.1
            whitecircle.fillColor   = UIColor(red:0.99, green: 1, blue:1, alpha:1).cgColor
            whitecircle.strokeColor = UIColor(red:0.404, green: 0.404, blue:0.404, alpha:1).cgColor
            whitecircle.lineWidth   = 0
        }
        if layerIds == nil || layerIds.contains("whitecircle2"){
            let whitecircle2 = layers["whitecircle2"] as! CAShapeLayer
            whitecircle2.opacity     = 0.1
            whitecircle2.fillColor   = UIColor(red:0.99, green: 1, blue:1, alpha:1).cgColor
            whitecircle2.strokeColor = UIColor(red:0.404, green: 0.404, blue:0.404, alpha:1).cgColor
            whitecircle2.lineWidth   = 0
        }
        if layerIds == nil || layerIds.contains("loadingcircle"){
            let loadingcircle = layers["loadingcircle"] as! CAShapeLayer
            loadingcircle.lineCap         = CAShapeLayerLineCap.round
            loadingcircle.fillColor       = nil
            loadingcircle.strokeColor     = UIColor(red:0.271, green: 0.741, blue:0.82, alpha:1).cgColor
            loadingcircle.lineWidth       = 4
            loadingcircle.strokeEnd       = 0.3
            loadingcircle.lineDashPattern = [0, 0.5]
        }
        if layerIds == nil || layerIds.contains("whitecircle3"){
            let whitecircle3 = layers["whitecircle3"] as! CAShapeLayer
            whitecircle3.fillColor   = self.color.cgColor
            whitecircle3.strokeColor = UIColor(red:0.404, green: 0.404, blue:0.404, alpha:1).cgColor
            whitecircle3.lineWidth   = 0
        }
        if layerIds == nil || layerIds.contains("whitecircle4"){
            let whitecircle4 = layers["whitecircle4"] as! CAShapeLayer
            whitecircle4.fillColor   = nil
            whitecircle4.strokeColor = self.blue.cgColor
            whitecircle4.lineWidth   = 5
        }
        if layerIds == nil || layerIds.contains("tick"){
            let tick = layers["tick"] as! CAShapeLayer
            tick.opacity     = 0
            tick.fillColor   = UIColor.black.cgColor
            tick.strokeColor = UIColor.black.cgColor
            tick.lineWidth   = 0
        }
        if layerIds == nil || layerIds.contains("lock"){
            let lock = layers["lock"] as! CAShapeLayer
            lock.fillColor   = UIColor.black.cgColor
            lock.strokeColor = UIColor.black.cgColor
            lock.lineWidth   = 0
        }
        if layerIds == nil || layerIds.contains("arrow"){
            let arrow = layers["arrow"] as! CAShapeLayer
            arrow.opacity     = 0
            arrow.fillColor   = self.color.cgColor
            arrow.strokeColor = UIColor.black.cgColor
            arrow.lineWidth   = 0
        }
        if layerIds == nil || layerIds.contains("min"){
            let min = layers["min"] as! CAShapeLayer
            min.opacity     = 0
            min.fillColor   = UIColor.black.cgColor
            min.strokeColor = UIColor.black.cgColor
            min.lineWidth   = 0
        }
        if layerIds == nil || layerIds.contains("min2"){
            let min2 = layers["min2"] as! CAShapeLayer
            min2.opacity     = 0
            min2.fillColor   = UIColor.black.cgColor
            min2.strokeColor = UIColor.black.cgColor
            min2.lineWidth   = 0
        }
        
        CATransaction.commit()
    }
    
    func setupLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        if let whitecircle = layers["whitecircle"] as? CAShapeLayer{
            whitecircle.frame = CGRect(x: 0.37412 * whitecircle.superlayer!.bounds.width, y: 0.37495 * whitecircle.superlayer!.bounds.height, width: 0.25176 * whitecircle.superlayer!.bounds.width, height: 0.25011 * whitecircle.superlayer!.bounds.height)
            whitecircle.path  = whitecirclePath(bounds: layers["whitecircle"]!.bounds).cgPath
        }
        
        if let whitecircle2 = layers["whitecircle2"] as? CAShapeLayer{
            whitecircle2.frame = CGRect(x: 0.37412 * whitecircle2.superlayer!.bounds.width, y: 0.37495 * whitecircle2.superlayer!.bounds.height, width: 0.25176 * whitecircle2.superlayer!.bounds.width, height: 0.25011 * whitecircle2.superlayer!.bounds.height)
            whitecircle2.path  = whitecircle2Path(bounds: layers["whitecircle2"]!.bounds).cgPath
        }
        
        if let loadingcircle = layers["loadingcircle"] as? CAShapeLayer{
            loadingcircle.frame = CGRect(x: 0.3532 * loadingcircle.superlayer!.bounds.width, y: 0.3532 * loadingcircle.superlayer!.bounds.height, width: 0.2936 * loadingcircle.superlayer!.bounds.width, height: 0.2936 * loadingcircle.superlayer!.bounds.height)
            loadingcircle.path  = loadingcirclePath(bounds: layers["loadingcircle"]!.bounds).cgPath
        }
        
        if let whitecircle3 = layers["whitecircle3"] as? CAShapeLayer{
            whitecircle3.frame = CGRect(x: 0.37412 * whitecircle3.superlayer!.bounds.width, y: 0.37495 * whitecircle3.superlayer!.bounds.height, width: 0.25176 * whitecircle3.superlayer!.bounds.width, height: 0.25011 * whitecircle3.superlayer!.bounds.height)
            whitecircle3.path  = whitecircle3Path(bounds: layers["whitecircle3"]!.bounds).cgPath
        }
        
        if let whitecircle4 = layers["whitecircle4"] as? CAShapeLayer{
            whitecircle4.frame = CGRect(x: 0.39315 * whitecircle4.superlayer!.bounds.width, y: 0.39315 * whitecircle4.superlayer!.bounds.height, width: 0.21369 * whitecircle4.superlayer!.bounds.width, height: 0.21369 * whitecircle4.superlayer!.bounds.height)
            whitecircle4.path  = whitecircle4Path(bounds: layers["whitecircle4"]!.bounds).cgPath
        }
        
        if let tick = layers["tick"] as? CAShapeLayer{
            tick.frame = CGRect(x: 0.44961 * tick.superlayer!.bounds.width, y: 0.46076 * tick.superlayer!.bounds.height, width: 0.10077 * tick.superlayer!.bounds.width, height: 0.07848 * tick.superlayer!.bounds.height)
            tick.path  = tickPath(bounds: layers["tick"]!.bounds).cgPath
        }
        
        if let lock = layers["lock"] as? CAShapeLayer{
            lock.frame = CGRect(x: 0.48533 * lock.superlayer!.bounds.width, y: 0.4737 * lock.superlayer!.bounds.height, width: 0.02935 * lock.superlayer!.bounds.width, height: 0.0526 * lock.superlayer!.bounds.height)
            lock.path  = lockPath(bounds: layers["lock"]!.bounds).cgPath
        }
        
        if let arrow = layers["arrow"] as? CAShapeLayer{
            arrow.frame = CGRect(x: 0.45306 * arrow.superlayer!.bounds.width, y: 0.47692 * arrow.superlayer!.bounds.height, width: 0.09387 * arrow.superlayer!.bounds.width, height: 0.13335 * arrow.superlayer!.bounds.height)
            arrow.path  = arrowPath(bounds: layers["arrow"]!.bounds).cgPath
        }
        
        if let min = layers["min"] as? CAShapeLayer{
            min.frame = CGRect(x: 0.44131 * min.superlayer!.bounds.width, y: 0.49835 * min.superlayer!.bounds.height, width: 0.11738 * min.superlayer!.bounds.width, height: 0.01667 * min.superlayer!.bounds.height)
            min.path  = minPath(bounds: layers["min"]!.bounds).cgPath
        }
        
        if let min2 = layers["min2"] as? CAShapeLayer{
            min2.frame = CGRect(x: 0.44131 * min2.superlayer!.bounds.width, y: 0.49835 * min2.superlayer!.bounds.height, width: 0.11738 * min2.superlayer!.bounds.width, height: 0.01667 * min2.superlayer!.bounds.height)
            min2.path  = min2Path(bounds: layers["min2"]!.bounds).cgPath
        }
        
        CATransaction.commit()
    }
    
    //MARK: - Animation Setup
    
    func addLoadingAnimation(completionBlock: ((_ finished: Bool) -> Void)? = nil){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = 15
            completionAnim.delegate = self
            completionAnim.setValue("loading", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            layer.add(completionAnim, forKey:"loading")
            if let anim = layer.animation(forKey: "loading"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        let fillMode : String = CAMediaTimingFillMode.forwards.rawValue
        
        let loadingcircle = layers["loadingcircle"] as! CAShapeLayer
        
        ////Loadingcircle animation
        let loadingcircleTransformAnim      = CAKeyframeAnimation(keyPath:"transform.rotation.z")
        loadingcircleTransformAnim.values   = [0,
                                               9000 * CGFloat.pi/180]
        loadingcircleTransformAnim.keyTimes = [0, 1]
        loadingcircleTransformAnim.duration = 15
        
        let loadingcircleLoadingAnim : CAAnimationGroup = QCMethod.group(animations: [loadingcircleTransformAnim], fillMode:fillMode)
        loadingcircle.add(loadingcircleLoadingAnim, forKey:"loadingcircleLoadingAnim")
        
        ////Tick animation
        let tickOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
        tickOpacityAnim.values   = [0, 0]
        tickOpacityAnim.keyTimes = [0, 1]
        tickOpacityAnim.duration = 15
        
        let tickLoadingAnim : CAAnimationGroup = QCMethod.group(animations: [tickOpacityAnim], fillMode:fillMode)
        layers["tick"]?.add(tickLoadingAnim, forKey:"tickLoadingAnim")
    }
    
    func addSuccessAnimation(completionBlock: ((_ finished: Bool) -> Void)? = nil){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = 1.962
            completionAnim.delegate = self
            completionAnim.setValue("success", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            layer.add(completionAnim, forKey:"success")
            if let anim = layer.animation(forKey: "success"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        let fillMode : String = CAMediaTimingFillMode.forwards.rawValue
        
        let whitecircle = layers["whitecircle"] as! CAShapeLayer
        
        ////Whitecircle animation
        let whitecircleTransformAnim       = CAKeyframeAnimation(keyPath:"transform")
        whitecircleTransformAnim.values    = [NSValue(caTransform3D: CATransform3DIdentity),
                                              NSValue(caTransform3D: CATransform3DMakeScale(2.8, 2.8, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(2.6, 2.6, 1))]
        whitecircleTransformAnim.keyTimes  = [0, 0.596, 1]
        whitecircleTransformAnim.duration  = 0.6
        whitecircleTransformAnim.beginTime = 0.443
        whitecircleTransformAnim.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let whitecircleSuccessAnim : CAAnimationGroup = QCMethod.group(animations: [whitecircleTransformAnim], fillMode:fillMode)
        whitecircle.add(whitecircleSuccessAnim, forKey:"whitecircleSuccessAnim")
        
        let whitecircle2 = layers["whitecircle2"] as! CAShapeLayer
        
        ////Whitecircle2 animation
        let whitecircle2TransformAnim       = CAKeyframeAnimation(keyPath:"transform")
        whitecircle2TransformAnim.values    = [NSValue(caTransform3D: CATransform3DIdentity),
                                               NSValue(caTransform3D: CATransform3DMakeScale(2.3, 2.3, 1)),
                                               NSValue(caTransform3D: CATransform3DMakeScale(2, 2, 1))]
        whitecircle2TransformAnim.keyTimes  = [0, 0.613, 1]
        whitecircle2TransformAnim.duration  = 0.447
        whitecircle2TransformAnim.beginTime = 0.443
        whitecircle2TransformAnim.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let whitecircle2SuccessAnim : CAAnimationGroup = QCMethod.group(animations: [whitecircle2TransformAnim], fillMode:fillMode)
        whitecircle2.add(whitecircle2SuccessAnim, forKey:"whitecircle2SuccessAnim")
        
        ////Loadingcircle animation
        let loadingcircleOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
        loadingcircleOpacityAnim.values   = [1, 0]
        loadingcircleOpacityAnim.keyTimes = [0, 1]
        loadingcircleOpacityAnim.duration = 0.278
        
        let loadingcircleSuccessAnim : CAAnimationGroup = QCMethod.group(animations: [loadingcircleOpacityAnim], fillMode:fillMode)
        layers["loadingcircle"]?.add(loadingcircleSuccessAnim, forKey:"loadingcircleSuccessAnim")
        
        let whitecircle3 = layers["whitecircle3"] as! CAShapeLayer
        
        ////Whitecircle3 animation
        let whitecircle3TransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        whitecircle3TransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                              NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(1.3, 1.3, 1))]
        whitecircle3TransformAnim.keyTimes = [0, 0.291, 0.724, 1]
        whitecircle3TransformAnim.duration = 0.61
        whitecircle3TransformAnim.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let whitecircle3OpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        whitecircle3OpacityAnim.values    = [1, 0.1]
        whitecircle3OpacityAnim.keyTimes  = [0, 1]
        whitecircle3OpacityAnim.duration  = 0.184
        whitecircle3OpacityAnim.beginTime = 0.621
        
        let whitecircle3SuccessAnim : CAAnimationGroup = QCMethod.group(animations: [whitecircle3TransformAnim, whitecircle3OpacityAnim], fillMode:fillMode)
        whitecircle3.add(whitecircle3SuccessAnim, forKey:"whitecircle3SuccessAnim")
        
        let whitecircle4 = layers["whitecircle4"] as! CAShapeLayer
        
        ////Whitecircle4 animation
        let whitecircle4TransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        whitecircle4TransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                              NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(1.8, 1.8, 1))]
        whitecircle4TransformAnim.keyTimes = [0, 0.213, 0.535, 1]
        whitecircle4TransformAnim.duration = 0.811
        whitecircle4TransformAnim.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let whitecircle4LineWidthAnim       = CAKeyframeAnimation(keyPath:"lineWidth")
        whitecircle4LineWidthAnim.values    = [5, 10, 0]
        whitecircle4LineWidthAnim.keyTimes  = [0, 0.564, 1]
        whitecircle4LineWidthAnim.duration  = 0.643
        whitecircle4LineWidthAnim.beginTime = 0.17
        
        let whitecircle4OpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        whitecircle4OpacityAnim.values    = [1, 0]
        whitecircle4OpacityAnim.keyTimes  = [0, 1]
        whitecircle4OpacityAnim.duration  = 0.357
        whitecircle4OpacityAnim.beginTime = 0.533
        
        let whitecircle4SuccessAnim : CAAnimationGroup = QCMethod.group(animations: [whitecircle4TransformAnim, whitecircle4LineWidthAnim, whitecircle4OpacityAnim], fillMode:fillMode)
        whitecircle4.add(whitecircle4SuccessAnim, forKey:"whitecircle4SuccessAnim")
        
        ////Tick animation
        let tickOpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        tickOpacityAnim.values    = [0, 1, 1, 0]
        tickOpacityAnim.keyTimes  = [0, 0.297, 0.968, 1]
        tickOpacityAnim.duration  = 1.22
        tickOpacityAnim.beginTime = 0.436
        
        let tick = layers["tick"] as! CAShapeLayer
        
        let tickTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        tickTransformAnim.values   = [NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1)),
                                      NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1)),
                                      NSValue(caTransform3D: CATransform3DMakeScale(1.7, 1.7, 1)),
                                      NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1)),
                                      NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1)),
                                      NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(0.5, 0.4, 1), CATransform3DMakeRotation(-CGFloat.pi, 0, 0, 1))),
                                      NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(0.5, 0.4, 1), CATransform3DMakeRotation(-CGFloat.pi, 0, 0, 1)))]
        tickTransformAnim.keyTimes = [0, 0.166, 0.31, 0.364, 0.698, 0.826, 1]
        tickTransformAnim.duration = 1.96
        
        let tickFillColorAnim       = CAKeyframeAnimation(keyPath:"fillColor")
        tickFillColorAnim.values    = [UIColor.black.cgColor,
                                       self.success.cgColor,
                                       self.color.cgColor]
        tickFillColorAnim.keyTimes  = [0, 0.592, 1]
        tickFillColorAnim.duration  = 0.478
        tickFillColorAnim.beginTime = 0.328
        
        let tickSuccessAnim : CAAnimationGroup = QCMethod.group(animations: [tickOpacityAnim, tickTransformAnim, tickFillColorAnim], fillMode:fillMode)
        tick.add(tickSuccessAnim, forKey:"tickSuccessAnim")
        
        ////Lock animation
        let lockOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
        lockOpacityAnim.values   = [1, 1, 0]
        lockOpacityAnim.keyTimes = [0, 0.536, 1]
        lockOpacityAnim.duration = 0.611
        
        let lock = layers["lock"] as! CAShapeLayer
        
        let lockTransformAnim       = CAKeyframeAnimation(keyPath:"transform")
        lockTransformAnim.values    = [NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1))]
        lockTransformAnim.keyTimes  = [0, 1]
        lockTransformAnim.duration  = 0.283
        lockTransformAnim.beginTime = 0.328
        
        let lockSuccessAnim : CAAnimationGroup = QCMethod.group(animations: [lockOpacityAnim, lockTransformAnim], fillMode:fillMode)
        lock.add(lockSuccessAnim, forKey:"lockSuccessAnim")
        
        let arrow = layers["arrow"] as! CAShapeLayer
        
        ////Arrow animation
        let arrowTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        arrowTransformAnim.values   = [NSValue(caTransform3D: CATransform3DMakeScale(0.6, 0.6, 1)),
                                       NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1)),
                                       NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1)),
                                       NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1)),
                                       NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1))]
        arrowTransformAnim.keyTimes = [0, 0.783, 0.826, 0.937, 1]
        arrowTransformAnim.duration = 1.96
        
        let arrowOpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        arrowOpacityAnim.values    = [0, 1]
        arrowOpacityAnim.keyTimes  = [0, 1]
        arrowOpacityAnim.duration  = 0.1
        arrowOpacityAnim.beginTime = 1.54
        
        let arrowPositionAnim       = CAKeyframeAnimation(keyPath:"position")
        arrowPositionAnim.values    = [NSValue(cgPoint: CGPoint(x: 0.5 * arrow.superlayer!.bounds.width, y: 0.52286 * arrow.superlayer!.bounds.height)), NSValue(cgPoint: CGPoint(x: 0.5 * arrow.superlayer!.bounds.width, y: 0.52286 * arrow.superlayer!.bounds.height)), NSValue(cgPoint: CGPoint(x: 0.5 * arrow.superlayer!.bounds.width, y: 0.49143 * arrow.superlayer!.bounds.height))]
        arrowPositionAnim.keyTimes  = [0, 0.459, 1]
        arrowPositionAnim.duration  = 0.405
        arrowPositionAnim.beginTime = 1.43
        
        let arrowSuccessAnim : CAAnimationGroup = QCMethod.group(animations: [arrowTransformAnim, arrowOpacityAnim, arrowPositionAnim], fillMode:fillMode)
        arrow.add(arrowSuccessAnim, forKey:"arrowSuccessAnim")
    }
    
    func addFailAnimation(completionBlock: ((_ finished: Bool) -> Void)? = nil){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = 3.995
            completionAnim.delegate = self
            completionAnim.setValue("fail", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            layer.add(completionAnim, forKey:"fail")
            if let anim = layer.animation(forKey: "fail"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        let fillMode : String = CAMediaTimingFillMode.forwards.rawValue
        
        let whitecircle = layers["whitecircle"] as! CAShapeLayer
        
        ////Whitecircle animation
        let whitecircleTransformAnim       = CAKeyframeAnimation(keyPath:"transform")
        whitecircleTransformAnim.values    = [NSValue(caTransform3D: CATransform3DIdentity),
                                              NSValue(caTransform3D: CATransform3DMakeScale(2.8, 2.8, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(2.6, 2.6, 1))]
        whitecircleTransformAnim.keyTimes  = [0, 0.596, 1]
        whitecircleTransformAnim.duration  = 0.6
        whitecircleTransformAnim.beginTime = 0.443
        whitecircleTransformAnim.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let whitecircleFailAnim : CAAnimationGroup = QCMethod.group(animations: [whitecircleTransformAnim], fillMode:fillMode)
        whitecircle.add(whitecircleFailAnim, forKey:"whitecircleFailAnim")
        
        let whitecircle2 = layers["whitecircle2"] as! CAShapeLayer
        
        ////Whitecircle2 animation
        let whitecircle2TransformAnim       = CAKeyframeAnimation(keyPath:"transform")
        whitecircle2TransformAnim.values    = [NSValue(caTransform3D: CATransform3DIdentity),
                                               NSValue(caTransform3D: CATransform3DMakeScale(2.3, 2.3, 1)),
                                               NSValue(caTransform3D: CATransform3DMakeScale(2, 2, 1))]
        whitecircle2TransformAnim.keyTimes  = [0, 0.613, 1]
        whitecircle2TransformAnim.duration  = 0.447
        whitecircle2TransformAnim.beginTime = 0.443
        whitecircle2TransformAnim.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let whitecircle2FailAnim : CAAnimationGroup = QCMethod.group(animations: [whitecircle2TransformAnim], fillMode:fillMode)
        whitecircle2.add(whitecircle2FailAnim, forKey:"whitecircle2FailAnim")
        
        ////Loadingcircle animation
        let loadingcircleOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
        loadingcircleOpacityAnim.values   = [1, 0]
        loadingcircleOpacityAnim.keyTimes = [0, 1]
        loadingcircleOpacityAnim.duration = 0.278
        
        let loadingcircleFailAnim : CAAnimationGroup = QCMethod.group(animations: [loadingcircleOpacityAnim], fillMode:fillMode)
        layers["loadingcircle"]?.add(loadingcircleFailAnim, forKey:"loadingcircleFailAnim")
        
        let whitecircle3 = layers["whitecircle3"] as! CAShapeLayer
        
        ////Whitecircle3 animation
        let whitecircle3TransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        whitecircle3TransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                              NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(1.3, 1.3, 1))]
        whitecircle3TransformAnim.keyTimes = [0, 0.291, 0.724, 1]
        whitecircle3TransformAnim.duration = 0.61
        whitecircle3TransformAnim.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let whitecircle3OpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        whitecircle3OpacityAnim.values    = [1, 0.1]
        whitecircle3OpacityAnim.keyTimes  = [0, 1]
        whitecircle3OpacityAnim.duration  = 0.184
        whitecircle3OpacityAnim.beginTime = 0.621
        
        let whitecircle3FailAnim : CAAnimationGroup = QCMethod.group(animations: [whitecircle3TransformAnim, whitecircle3OpacityAnim], fillMode:fillMode)
        whitecircle3.add(whitecircle3FailAnim, forKey:"whitecircle3FailAnim")
        
        let whitecircle4 = layers["whitecircle4"] as! CAShapeLayer
        
        ////Whitecircle4 animation
        let whitecircle4TransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        whitecircle4TransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                              NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(0.8, 0.8, 1)),
                                              NSValue(caTransform3D: CATransform3DMakeScale(1.8, 1.8, 1))]
        whitecircle4TransformAnim.keyTimes = [0, 0.213, 0.535, 1]
        whitecircle4TransformAnim.duration = 0.811
        whitecircle4TransformAnim.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        let whitecircle4LineWidthAnim       = CAKeyframeAnimation(keyPath:"lineWidth")
        whitecircle4LineWidthAnim.values    = [5, 10, 0]
        whitecircle4LineWidthAnim.keyTimes  = [0, 0.564, 1]
        whitecircle4LineWidthAnim.duration  = 0.643
        whitecircle4LineWidthAnim.beginTime = 0.17
        
        let whitecircle4OpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        whitecircle4OpacityAnim.values    = [1, 0]
        whitecircle4OpacityAnim.keyTimes  = [0, 1]
        whitecircle4OpacityAnim.duration  = 0.357
        whitecircle4OpacityAnim.beginTime = 0.533
        
        let whitecircle4FailAnim : CAAnimationGroup = QCMethod.group(animations: [whitecircle4TransformAnim, whitecircle4LineWidthAnim, whitecircle4OpacityAnim], fillMode:fillMode)
        whitecircle4.add(whitecircle4FailAnim, forKey:"whitecircle4FailAnim")
        
        ////Lock animation
        let lockOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
        lockOpacityAnim.values   = [1, 1, 0]
        lockOpacityAnim.keyTimes = [0, 0.536, 1]
        lockOpacityAnim.duration = 0.611
        
        let lock = layers["lock"] as! CAShapeLayer
        
        let lockTransformAnim       = CAKeyframeAnimation(keyPath:"transform")
        lockTransformAnim.values    = [NSValue(caTransform3D: CATransform3DIdentity),
                                       NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1))]
        lockTransformAnim.keyTimes  = [0, 1]
        lockTransformAnim.duration  = 0.283
        lockTransformAnim.beginTime = 0.328
        
        let lockFailAnim : CAAnimationGroup = QCMethod.group(animations: [lockOpacityAnim, lockTransformAnim], fillMode:fillMode)
        lock.add(lockFailAnim, forKey:"lockFailAnim")
        
        ////Arrow animation
        let arrowOpacityAnim      = CAKeyframeAnimation(keyPath:"opacity")
        arrowOpacityAnim.values   = [0, 0]
        arrowOpacityAnim.keyTimes = [0, 1]
        arrowOpacityAnim.duration = 4
        
        let arrowFailAnim : CAAnimationGroup = QCMethod.group(animations: [arrowOpacityAnim], fillMode:fillMode)
        layers["arrow"]?.add(arrowFailAnim, forKey:"arrowFailAnim")
        
        let min = layers["min"] as! CAShapeLayer
        
        ////Min animation
        let minTransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        minTransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                     NSValue(caTransform3D: CATransform3DIdentity),
                                     NSValue(caTransform3D: CATransform3DMakeScale(1.7, 1.7, 1)),
                                     NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1)),
                                     NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1)),
                                     NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(60 * CGFloat.pi/180, 0, -0, 1))),
                                     NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(45 * CGFloat.pi/180, 0, -0, 1))),
                                     NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(45 * CGFloat.pi/180, 0, -0, 1)))]
        minTransformAnim.keyTimes = [0, 0.167, 0.309, 0.366, 0.699, 0.781, 0.825, 1]
        minTransformAnim.duration = 1.96
        
        let minFillColorAnim       = CAKeyframeAnimation(keyPath:"fillColor")
        minFillColorAnim.values    = [UIColor.black.cgColor,
                                      self.error.cgColor,
                                      self.color.cgColor]
        minFillColorAnim.keyTimes  = [0, 0.584, 1]
        minFillColorAnim.duration  = 0.484
        minFillColorAnim.beginTime = 0.329
        
        let minOpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        minOpacityAnim.values    = [0, 1]
        minOpacityAnim.keyTimes  = [0, 1]
        minOpacityAnim.duration  = 0.371
        minOpacityAnim.beginTime = 0.441
        
        let minFailAnim : CAAnimationGroup = QCMethod.group(animations: [minTransformAnim, minFillColorAnim, minOpacityAnim], fillMode:fillMode)
        min.add(minFailAnim, forKey:"minFailAnim")
        
        let min2 = layers["min2"] as! CAShapeLayer
        
        ////Min2 animation
        let min2TransformAnim      = CAKeyframeAnimation(keyPath:"transform")
        min2TransformAnim.values   = [NSValue(caTransform3D: CATransform3DIdentity),
                                      NSValue(caTransform3D: CATransform3DIdentity),
                                      NSValue(caTransform3D: CATransform3DMakeScale(1.7, 1.7, 1)),
                                      NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1)),
                                      NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1)),
                                      NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(-60 * CGFloat.pi/180, -0, 0, 1))),
                                      NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(-CGFloat.pi/4, 0, 0, 1))),
                                      NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeScale(1.5, 1.5, 1), CATransform3DMakeRotation(-CGFloat.pi/4, 0, 0, 1)))]
        min2TransformAnim.keyTimes = [0, 0.167, 0.309, 0.366, 0.699, 0.781, 0.825, 1]
        min2TransformAnim.duration = 1.96
        
        let min2FillColorAnim       = CAKeyframeAnimation(keyPath:"fillColor")
        min2FillColorAnim.values    = [UIColor.black.cgColor,
                                       UIColor(red:0.976, green: 0.196, blue:0.318, alpha:1).cgColor,
                                       UIColor(red:0.99, green: 1, blue:1, alpha:1).cgColor]
        min2FillColorAnim.keyTimes  = [0, 0.584, 1]
        min2FillColorAnim.duration  = 0.484
        min2FillColorAnim.beginTime = 0.329
        
        let min2OpacityAnim       = CAKeyframeAnimation(keyPath:"opacity")
        min2OpacityAnim.values    = [0, 1]
        min2OpacityAnim.keyTimes  = [0, 1]
        min2OpacityAnim.duration  = 0.371
        min2OpacityAnim.beginTime = 0.441
        
        let min2FailAnim : CAAnimationGroup = QCMethod.group(animations: [min2TransformAnim, min2FillColorAnim, min2OpacityAnim], fillMode:fillMode)
        min2.add(min2FailAnim, forKey:"min2FailAnim")
    }
    
    //MARK: - Animation Cleanup
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if let completionBlock = completionBlocks[anim]{
            completionBlocks.removeValue(forKey: anim)
            if (flag && updateLayerValueForCompletedAnimation) || anim.value(forKey: "needEndAnim") as! Bool{
                updateLayerValues(forAnimationId: anim.value(forKey: "animId") as! String)
                removeAnimations(forAnimationId: anim.value(forKey: "animId") as! String)
            }
            completionBlock(flag)
        }
    }
    
    func updateLayerValues(forAnimationId identifier: String){
        if identifier == "loading"{
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["loadingcircle"]!.animation(forKey: "loadingcircleLoadingAnim"), theLayer:layers["loadingcircle"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["tick"]!.animation(forKey: "tickLoadingAnim"), theLayer:layers["tick"]!)
        }
        else if identifier == "success"{
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["whitecircle"]!.animation(forKey: "whitecircleSuccessAnim"), theLayer:layers["whitecircle"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["whitecircle2"]!.animation(forKey: "whitecircle2SuccessAnim"), theLayer:layers["whitecircle2"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["loadingcircle"]!.animation(forKey: "loadingcircleSuccessAnim"), theLayer:layers["loadingcircle"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["whitecircle3"]!.animation(forKey: "whitecircle3SuccessAnim"), theLayer:layers["whitecircle3"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["whitecircle4"]!.animation(forKey: "whitecircle4SuccessAnim"), theLayer:layers["whitecircle4"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["tick"]!.animation(forKey: "tickSuccessAnim"), theLayer:layers["tick"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["lock"]!.animation(forKey: "lockSuccessAnim"), theLayer:layers["lock"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["arrow"]!.animation(forKey: "arrowSuccessAnim"), theLayer:layers["arrow"]!)
        }
        else if identifier == "fail"{
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["whitecircle"]!.animation(forKey: "whitecircleFailAnim"), theLayer:layers["whitecircle"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["whitecircle2"]!.animation(forKey: "whitecircle2FailAnim"), theLayer:layers["whitecircle2"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["loadingcircle"]!.animation(forKey: "loadingcircleFailAnim"), theLayer:layers["loadingcircle"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["whitecircle3"]!.animation(forKey: "whitecircle3FailAnim"), theLayer:layers["whitecircle3"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["whitecircle4"]!.animation(forKey: "whitecircle4FailAnim"), theLayer:layers["whitecircle4"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["lock"]!.animation(forKey: "lockFailAnim"), theLayer:layers["lock"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["arrow"]!.animation(forKey: "arrowFailAnim"), theLayer:layers["arrow"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["min"]!.animation(forKey: "minFailAnim"), theLayer:layers["min"]!)
            QCMethod.updateValueFromPresentationLayer(forAnimation: layers["min2"]!.animation(forKey: "min2FailAnim"), theLayer:layers["min2"]!)
        }
    }
    
    func removeAnimations(forAnimationId identifier: String){
        if identifier == "loading"{
            layers["loadingcircle"]?.removeAnimation(forKey: "loadingcircleLoadingAnim")
            layers["tick"]?.removeAnimation(forKey: "tickLoadingAnim")
        }
        else if identifier == "success"{
            layers["whitecircle"]?.removeAnimation(forKey: "whitecircleSuccessAnim")
            layers["whitecircle2"]?.removeAnimation(forKey: "whitecircle2SuccessAnim")
            layers["loadingcircle"]?.removeAnimation(forKey: "loadingcircleSuccessAnim")
            layers["whitecircle3"]?.removeAnimation(forKey: "whitecircle3SuccessAnim")
            layers["whitecircle4"]?.removeAnimation(forKey: "whitecircle4SuccessAnim")
            layers["tick"]?.removeAnimation(forKey: "tickSuccessAnim")
            layers["lock"]?.removeAnimation(forKey: "lockSuccessAnim")
            layers["arrow"]?.removeAnimation(forKey: "arrowSuccessAnim")
        }
        else if identifier == "fail"{
            layers["whitecircle"]?.removeAnimation(forKey: "whitecircleFailAnim")
            layers["whitecircle2"]?.removeAnimation(forKey: "whitecircle2FailAnim")
            layers["loadingcircle"]?.removeAnimation(forKey: "loadingcircleFailAnim")
            layers["whitecircle3"]?.removeAnimation(forKey: "whitecircle3FailAnim")
            layers["whitecircle4"]?.removeAnimation(forKey: "whitecircle4FailAnim")
            layers["lock"]?.removeAnimation(forKey: "lockFailAnim")
            layers["arrow"]?.removeAnimation(forKey: "arrowFailAnim")
            layers["min"]?.removeAnimation(forKey: "minFailAnim")
            layers["min2"]?.removeAnimation(forKey: "min2FailAnim")
        }
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            layer.removeAllAnimations()
        }
    }
    
    //MARK: - Bezier Path
    
    func whitecirclePath(bounds: CGRect) -> UIBezierPath{
        let whitecirclePath = UIBezierPath(ovalIn:bounds)
        return whitecirclePath
    }
    
    func whitecircle2Path(bounds: CGRect) -> UIBezierPath{
        let whitecircle2Path = UIBezierPath(ovalIn:bounds)
        return whitecircle2Path
    }
    
    func loadingcirclePath(bounds: CGRect) -> UIBezierPath{
        let loadingcirclePath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        loadingcirclePath.move(to: CGPoint(x:minX + 0.5 * w, y: minY))
        loadingcirclePath.addCurve(to: CGPoint(x:minX, y: minY + 0.5 * h), controlPoint1:CGPoint(x:minX + 0.22386 * w, y: minY), controlPoint2:CGPoint(x:minX, y: minY + 0.22386 * h))
        loadingcirclePath.addCurve(to: CGPoint(x:minX + 0.5 * w, y: minY + h), controlPoint1:CGPoint(x:minX, y: minY + 0.77614 * h), controlPoint2:CGPoint(x:minX + 0.22386 * w, y: minY + h))
        loadingcirclePath.addCurve(to: CGPoint(x:minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x:minX + 0.77614 * w, y: minY + h), controlPoint2:CGPoint(x:minX + w, y: minY + 0.77614 * h))
        loadingcirclePath.addCurve(to: CGPoint(x:minX + 0.5 * w, y: minY), controlPoint1:CGPoint(x:minX + w, y: minY + 0.22386 * h), controlPoint2:CGPoint(x:minX + 0.77614 * w, y: minY))
        
        return loadingcirclePath
    }
    
    func whitecircle3Path(bounds: CGRect) -> UIBezierPath{
        let whitecircle3Path = UIBezierPath(ovalIn:bounds)
        return whitecircle3Path
    }
    
    func whitecircle4Path(bounds: CGRect) -> UIBezierPath{
        let whitecircle4Path = UIBezierPath(ovalIn:bounds)
        return whitecircle4Path
    }
    
    func tickPath(bounds: CGRect) -> UIBezierPath{
        let tickPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        tickPath.move(to: CGPoint(x:minX + 0.40155 * w, y: minY + h))
        tickPath.addLine(to: CGPoint(x:minX + 0.02761 * w, y: minY + 0.57296 * h))
        tickPath.addCurve(to: CGPoint(x:minX + 0.02099 * w, y: minY + 0.42212 * h), controlPoint1:CGPoint(x:minX + -0.00714 * w, y: minY + 0.53472 * h), controlPoint2:CGPoint(x:minX + -0.00879 * w, y: minY + 0.46673 * h))
        tickPath.addCurve(to: CGPoint(x:minX + 0.13847 * w, y: minY + 0.41362 * h), controlPoint1:CGPoint(x:minX + 0.05077 * w, y: minY + 0.3775 * h), controlPoint2:CGPoint(x:minX + 0.10372 * w, y: minY + 0.37325 * h))
        tickPath.addLine(to: CGPoint(x:minX + 0.38997 * w, y: minY + 0.70044 * h))
        tickPath.addLine(to: CGPoint(x:minX + 0.85491 * w, y: minY + 0.03545 * h))
        tickPath.addCurve(to: CGPoint(x:minX + 0.97239 * w, y: minY + 0.02695 * h), controlPoint1:CGPoint(x:minX + 0.8847 * w, y: minY + -0.00917 * h), controlPoint2:CGPoint(x:minX + 0.93765 * w, y: minY + -0.01129 * h))
        tickPath.addCurve(to: CGPoint(x:minX + 0.97901 * w, y: minY + 0.17779 * h), controlPoint1:CGPoint(x:minX + 1.00714 * w, y: minY + 0.06519 * h), controlPoint2:CGPoint(x:minX + 1.00879 * w, y: minY + 0.13318 * h))
        tickPath.addLine(to: CGPoint(x:minX + 0.40155 * w, y: minY + h))
        tickPath.close()
        tickPath.move(to: CGPoint(x:minX + 0.40155 * w, y: minY + h))
        
        return tickPath
    }
    
    func lockPath(bounds: CGRect) -> UIBezierPath{
        let lockPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        lockPath.move(to: CGPoint(x:minX + 0.93396 * w, y: minY + 0.92632 * h))
        lockPath.addCurve(to: CGPoint(x:minX + 0.90566 * w, y: minY + 0.97895 * h), controlPoint1:CGPoint(x:minX + 0.93396 * w, y: minY + 0.94737 * h), controlPoint2:CGPoint(x:minX + 0.92453 * w, y: minY + 0.96316 * h))
        lockPath.addCurve(to: CGPoint(x:minX + 0.81132 * w, y: minY + h), controlPoint1:CGPoint(x:minX + 0.88679 * w, y: minY + 0.99474 * h), controlPoint2:CGPoint(x:minX + 0.84906 * w, y: minY + h))
        lockPath.addLine(to: CGPoint(x:minX + 0.18868 * w, y: minY + h))
        lockPath.addCurve(to: CGPoint(x:minX + 0.09434 * w, y: minY + 0.97895 * h), controlPoint1:CGPoint(x:minX + 0.15094 * w, y: minY + h), controlPoint2:CGPoint(x:minX + 0.12264 * w, y: minY + 0.98947 * h))
        lockPath.addCurve(to: CGPoint(x:minX + 0.06604 * w, y: minY + 0.92632 * h), controlPoint1:CGPoint(x:minX + 0.07547 * w, y: minY + 0.96316 * h), controlPoint2:CGPoint(x:minX + 0.0566 * w, y: minY + 0.94211 * h))
        lockPath.addLine(to: CGPoint(x:minX + 0.20755 * w, y: minY + 0.5 * h))
        lockPath.addCurve(to: CGPoint(x:minX, y: minY + 0.27895 * h), controlPoint1:CGPoint(x:minX + 0.07547 * w, y: minY + 0.44737 * h), controlPoint2:CGPoint(x:minX, y: minY + 0.36842 * h))
        lockPath.addCurve(to: CGPoint(x:minX + 0.5 * w, y: minY), controlPoint1:CGPoint(x:minX, y: minY + 0.12632 * h), controlPoint2:CGPoint(x:minX + 0.22642 * w, y: minY))
        lockPath.addCurve(to: CGPoint(x:minX + w, y: minY + 0.27895 * h), controlPoint1:CGPoint(x:minX + 0.77358 * w, y: minY), controlPoint2:CGPoint(x:minX + w, y: minY + 0.12632 * h))
        lockPath.addCurve(to: CGPoint(x:minX + 0.79245 * w, y: minY + 0.5 * h), controlPoint1:CGPoint(x:minX + w, y: minY + 0.36842 * h), controlPoint2:CGPoint(x:minX + 0.92453 * w, y: minY + 0.45263 * h))
        lockPath.addLine(to: CGPoint(x:minX + 0.93396 * w, y: minY + 0.92632 * h))
        lockPath.close()
        lockPath.move(to: CGPoint(x:minX + 0.93396 * w, y: minY + 0.92632 * h))
        
        return lockPath
    }
    
    func arrowPath(bounds: CGRect) -> UIBezierPath{
        let arrowPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        arrowPath.move(to: CGPoint(x:minX + 0.50089 * w, y: minY + h))
        arrowPath.addCurve(to: CGPoint(x:minX + 0.40675 * w, y: minY + 0.93373 * h), controlPoint1:CGPoint(x:minX + 0.44938 * w, y: minY + h), controlPoint2:CGPoint(x:minX + 0.40675 * w, y: minY + 0.96999 * h))
        arrowPath.addLine(to: CGPoint(x:minX + 0.40675 * w, y: minY + 0.22851 * h))
        arrowPath.addLine(to: CGPoint(x:minX + 0.16341 * w, y: minY + 0.39856 * h))
        arrowPath.addCurve(to: CGPoint(x:minX + 0.09591 * w, y: minY + 0.41857 * h), controlPoint1:CGPoint(x:minX + 0.14565 * w, y: minY + 0.41107 * h), controlPoint2:CGPoint(x:minX + 0.12078 * w, y: minY + 0.41857 * h))
        arrowPath.addCurve(to: CGPoint(x:minX + 0.02842 * w, y: minY + 0.39856 * h), controlPoint1:CGPoint(x:minX + 0.07105 * w, y: minY + 0.41857 * h), controlPoint2:CGPoint(x:minX + 0.04618 * w, y: minY + 0.41107 * h))
        arrowPath.addCurve(to: CGPoint(x:minX, y: minY + 0.35105 * h), controlPoint1:CGPoint(x:minX + 0.01066 * w, y: minY + 0.38606 * h), controlPoint2:CGPoint(x:minX, y: minY + 0.36855 * h))
        arrowPath.addCurve(to: CGPoint(x:minX + 0.02842 * w, y: minY + 0.30353 * h), controlPoint1:CGPoint(x:minX, y: minY + 0.33354 * h), controlPoint2:CGPoint(x:minX + 0.01066 * w, y: minY + 0.31604 * h))
        arrowPath.addLine(to: CGPoint(x:minX + 0.43339 * w, y: minY + 0.01969 * h))
        arrowPath.addCurve(to: CGPoint(x:minX + 0.56838 * w, y: minY + 0.01969 * h), controlPoint1:CGPoint(x:minX + 0.47069 * w, y: minY + -0.00656 * h), controlPoint2:CGPoint(x:minX + 0.53108 * w, y: minY + -0.00656 * h))
        arrowPath.addLine(to: CGPoint(x:minX + 0.97158 * w, y: minY + 0.30353 * h))
        arrowPath.addCurve(to: CGPoint(x:minX + w, y: minY + 0.35105 * h), controlPoint1:CGPoint(x:minX + 0.98934 * w, y: minY + 0.31604 * h), controlPoint2:CGPoint(x:minX + w, y: minY + 0.33354 * h))
        arrowPath.addCurve(to: CGPoint(x:minX + 0.97158 * w, y: minY + 0.39856 * h), controlPoint1:CGPoint(x:minX + w, y: minY + 0.36855 * h), controlPoint2:CGPoint(x:minX + 0.98934 * w, y: minY + 0.38606 * h))
        arrowPath.addCurve(to: CGPoint(x:minX + 0.90409 * w, y: minY + 0.41857 * h), controlPoint1:CGPoint(x:minX + 0.95382 * w, y: minY + 0.41107 * h), controlPoint2:CGPoint(x:minX + 0.92895 * w, y: minY + 0.41857 * h))
        arrowPath.addCurve(to: CGPoint(x:minX + 0.83659 * w, y: minY + 0.39856 * h), controlPoint1:CGPoint(x:minX + 0.87922 * w, y: minY + 0.41857 * h), controlPoint2:CGPoint(x:minX + 0.85435 * w, y: minY + 0.41107 * h))
        arrowPath.addLine(to: CGPoint(x:minX + 0.59503 * w, y: minY + 0.22851 * h))
        arrowPath.addLine(to: CGPoint(x:minX + 0.59503 * w, y: minY + 0.93373 * h))
        arrowPath.addCurve(to: CGPoint(x:minX + 0.50089 * w, y: minY + h), controlPoint1:CGPoint(x:minX + 0.59503 * w, y: minY + 0.96999 * h), controlPoint2:CGPoint(x:minX + 0.5524 * w, y: minY + h))
        arrowPath.close()
        arrowPath.move(to: CGPoint(x:minX + 0.50089 * w, y: minY + h))
        
        return arrowPath
    }
    
    func minPath(bounds: CGRect) -> UIBezierPath{
        let minPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        minPath.move(to: CGPoint(x:minX + 0.92898 * w, y: minY + h))
        minPath.addLine(to: CGPoint(x:minX + 0.07102 * w, y: minY + h))
        minPath.addCurve(to: CGPoint(x:minX, y: minY + 0.5 * h), controlPoint1:CGPoint(x:minX + 0.03125 * w, y: minY + h), controlPoint2:CGPoint(x:minX, y: minY + 0.78 * h))
        minPath.addCurve(to: CGPoint(x:minX + 0.07102 * w, y: minY), controlPoint1:CGPoint(x:minX, y: minY + 0.22 * h), controlPoint2:CGPoint(x:minX + 0.03125 * w, y: minY))
        minPath.addLine(to: CGPoint(x:minX + 0.92898 * w, y: minY))
        minPath.addCurve(to: CGPoint(x:minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x:minX + 0.96875 * w, y: minY), controlPoint2:CGPoint(x:minX + w, y: minY + 0.22 * h))
        minPath.addCurve(to: CGPoint(x:minX + 0.92898 * w, y: minY + h), controlPoint1:CGPoint(x:minX + w, y: minY + 0.77 * h), controlPoint2:CGPoint(x:minX + 0.96875 * w, y: minY + h))
        minPath.close()
        minPath.move(to: CGPoint(x:minX + 0.92898 * w, y: minY + h))
        
        return minPath
    }
    
    func min2Path(bounds: CGRect) -> UIBezierPath{
        let min2Path = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height;
        
        min2Path.move(to: CGPoint(x:minX + 0.92898 * w, y: minY + h))
        min2Path.addLine(to: CGPoint(x:minX + 0.07102 * w, y: minY + h))
        min2Path.addCurve(to: CGPoint(x:minX, y: minY + 0.5 * h), controlPoint1:CGPoint(x:minX + 0.03125 * w, y: minY + h), controlPoint2:CGPoint(x:minX, y: minY + 0.78 * h))
        min2Path.addCurve(to: CGPoint(x:minX + 0.07102 * w, y: minY), controlPoint1:CGPoint(x:minX, y: minY + 0.22 * h), controlPoint2:CGPoint(x:minX + 0.03125 * w, y: minY))
        min2Path.addLine(to: CGPoint(x:minX + 0.92898 * w, y: minY))
        min2Path.addCurve(to: CGPoint(x:minX + w, y: minY + 0.5 * h), controlPoint1:CGPoint(x:minX + 0.96875 * w, y: minY), controlPoint2:CGPoint(x:minX + w, y: minY + 0.22 * h))
        min2Path.addCurve(to: CGPoint(x:minX + 0.92898 * w, y: minY + h), controlPoint1:CGPoint(x:minX + w, y: minY + 0.77 * h), controlPoint2:CGPoint(x:minX + 0.96875 * w, y: minY + h))
        min2Path.close()
        min2Path.move(to: CGPoint(x:minX + 0.92898 * w, y: minY + h))
        
        return min2Path
    }
    
    
}
