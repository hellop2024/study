//
//  ViewController.swift
//  ScaleMaker
//
//  Created by YS P on 4/23/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var warningLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var doView: UIView!
    
    @IBOutlet weak var reView: UIView!
    
    @IBOutlet weak var miView: UIView!
    
    @IBOutlet weak var faView: UIView!
    
    @IBOutlet weak var solView: UIView!
    
    @IBOutlet weak var laView: UIView!
    
    @IBOutlet weak var tiView: UIView!
    
    @IBOutlet weak var inputDisplayLabel: UILabel!
    
    @IBOutlet weak var speedSlider: UISlider!
    
    // 음악 재생을 위한 변수
    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    var timer: Timer?
    
    // 음계와 해당하는 뷰 및 파일 이름을 매핑할 배열 선언
    var scaleMapping: [(view: UIView, fileName: String, color: UIColor)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        warningLabel.isHidden = true
        
        speedSlider.minimumValue = 0.5 // 최소 재생 속도
        speedSlider.maximumValue = 2.0 // 최대 재생 속도
        speedSlider.value = (speedSlider.maximumValue + speedSlider.minimumValue) / 2
        
        makeViewsCircular() // 뷰들을 동그라미 모양으로 만들기
        
        // scaleMapping 배열 초기화
        scaleMapping = [
            (doView, "0doView.mp3", .red),
            (reView, "1reView.mp3", .orange),
            (miView, "2miView.mp3", .yellow),
            (faView, "3faView.mp3", .green),
            (solView, "4solView.mp3", .blue),
            (laView, "5laView.mp3", .systemIndigo),
            (tiView, "6tiView.mp3", .purple)
        ]
        
    }
    
    @IBAction func inputButtonTapped(_ sender: UIButton) {
        if let text = inputTextField.text, !text.isEmpty {
            warningLabel.isHidden = true
            inputDisplayLabel.text = text
        } else {
            warningLabel.text = "제목을 한 글자 이상 입력하세요."
            warningLabel.isHidden = false
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        isPlaying.toggle() // 재생 상태 토글
        if isPlaying {
            playButton.setTitle("Stop", for: .normal)
            speedSlider.isEnabled = false
            startPlayingScales()
        } else {
            playButton.setTitle("Play", for: .normal)
            speedSlider.isEnabled = true
            stopPlayingScales()
        }
    }
    
    // 모든 뷰를 동그라미 모양으로 만들기
    func makeViewsCircular() {
        let views = [doView, reView, miView, faView, solView, laView, tiView]
        for view in views {
            if let view = view {
                view.layer.cornerRadius = view.frame.size.width / 2
                view.clipsToBounds = true
            }
        }
    }
    
    // 음계 재생 시작
    func startPlayingScales() {
        playScale(index: 0)
    }
    
    // 음계 재생 중지
    func stopPlayingScales() {
        timer?.invalidate()
        timer = nil
        audioPlayer?.stop()
        resetViewColors()
    }
    
    // 모든 뷰의 색상 초기화
    func resetViewColors() {
        let views = [doView, reView, miView, faView, solView, laView, tiView]
        for view in views {
            view?.backgroundColor = .lightGray // 초기 색상으로 설정
        }
    }
    
    // 지정된 인덱스의 음계 재생
    func playScale(index: Int) {
        if index >= scaleMapping.count {
            resetViewColors() // 모든 뷰의 색상을 초기화
        }
        
        let scale = scaleMapping[index % scaleMapping.count]
        let view = scale.view
        let fileName = scale.fileName
        let color = scale.color
        
        // 뷰 색상 변경
        UIView.animate(withDuration: 0.2) {
            view.backgroundColor = color
        }
        
        // 음악 파일 재생
        if let path = Bundle.main.path(forResource: fileName, ofType: nil) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("음악 파일을 재생할 수 없습니다.")
            }
        }
        
        // 다음 음계 재생을 위한 타이머 설정
        let playbackSpeed = TimeInterval(speedSlider.value)
        timer = Timer.scheduledTimer(withTimeInterval: playbackSpeed, repeats: false) { [weak self] _ in
            self?.playScale(index: index + 1)
        }
    }
}



