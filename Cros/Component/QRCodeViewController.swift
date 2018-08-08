//
//  QRCodeViewController.swift
//  TestSwiftApp
//
//  Created by fanlv on 2018/5/11.
//  Copyright © 2018年 bytedance. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //相机显示视图
    let cameraView = QRcodeView(frame: UIScreen.main.bounds)

    let captureSession = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫一扫"
        self.view.backgroundColor = UIColor.black
        //设置导航栏
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(QRCodeViewController.selectPhotoFormPhotoLibrary(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem

        self.view.addSubview(cameraView)

        //初始化捕捉设备（AVCaptureDevice），类型AVMdeiaTypeVideo
        let captureDevice = AVCaptureDevice.default(for: .video)

        let input: AVCaptureDeviceInput

        //创建媒体数据输出流
        let output = AVCaptureMetadataOutput()

        //捕捉异常
        do {
            //创建输入流
            input = try AVCaptureDeviceInput(device: captureDevice!)

            //把输入流添加到会话
            captureSession.addInput(input)

            //把输出流添加到会话
            captureSession.addOutput(output)
        } catch {
            print("异常")
        }

        //创建串行队列
        let dispatchQueue = DispatchQueue(label: "queue", attributes: [])

        //设置输出流的代理
        output.setMetadataObjectsDelegate(self, queue: dispatchQueue)

        //设置输出媒体的数据类型
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.code128]

        //创建预览图层
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        //设置预览图层的填充方式
        videoPreviewLayer.videoGravity = .resizeAspectFill

        //设置预览图层的frame
        videoPreviewLayer.frame = cameraView.bounds

        //将预览图层添加到预览视图上
        cameraView.layer.insertSublayer(videoPreviewLayer, at: 0)

        //设置扫描范围
        output.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.scannerStart()
    }

    func scannerStart() {
        captureSession.startRunning()
        cameraView.scanning = "start"
    }

    func scannerStop() {
        captureSession.stopRunning()
        cameraView.scanning = "stop"
    }

    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if  metadataObjects.count > 0 {
            let metaData: AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            print(metaData.stringValue ?? "nil")
            if (metaData.stringValue?.hasPrefix("sslocal"))! {
                captureSession.stopRunning()
            }
        }
    }

    //从相册中选择图片
    @objc func selectPhotoFormPhotoLibrary(_ sender: AnyObject) {
        let picture = UIImagePickerController()
        picture.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picture.delegate = self
        self.present(picture, animated: true, completion: nil)

    }

    //选择相册中的图片完成，进行获取二维码信息

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage]

        let imageData = UIImagePNGRepresentation(image as! UIImage)

        let ciImage = CIImage(data: imageData!)

        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])

        let array = detector?.features(in: ciImage!)

        let result: CIQRCodeFeature = array!.first as! CIQRCodeFeature

        picker.dismiss(animated: true, completion: nil)
        print(result.messageString ?? "")

        if (result.messageString?.hasPrefix("http://"))! {
//            EERoute.shared().openURL(byPushViewController: NSURL.init(string: result.messageString!)! as URL)
            picker.dismiss(animated: true, completion: nil)
        }

    }
}
