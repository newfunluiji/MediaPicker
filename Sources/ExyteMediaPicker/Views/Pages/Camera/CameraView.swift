//
//  Created by Alex.M on 31.05.2022.
//

import SwiftUI
import Photos

struct CameraView: View {

    @ObservedObject var viewModel: MediaPickerViewModel
    let didTakePicture: () -> Void

    @StateObject private var cameraViewModel = CameraViewModel()
    @EnvironmentObject private var cameraSelectionService: CameraSelectionService
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.mediaPickerTheme) private var theme

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") {
                    if cameraSelectionService.hasSelected {
                        viewModel.showingExitCameraConfirmation = true
                    } else {
                        viewModel.setPickerMode(.photos)
                    }
                }
                .foregroundColor(.white)
                .padding(.top, safeAreaInsets.top)
                .padding(.leading)
                .padding(.bottom)

                Spacer()
            }

            LiveCameraView(
                session: cameraViewModel.captureSession,
                videoGravity: .resizeAspectFill,
                orientation: .portrait
            )
            .overlay {
                if cameraViewModel.snapOverlay {
                    Rectangle()
                }
            }
            .gesture(
                MagnificationGesture()
                    .onChanged(cameraViewModel.zoomChanged(_:))
                    .onEnded(cameraViewModel.zoomEnded(_:))
            )

            VStack(spacing: 0) {
                if cameraSelectionService.hasSelected {
                    HStack {
                        Button("Done") {
                            if cameraSelectionService.hasSelected {
                                viewModel.setPickerMode(.cameraSelection)
                            }
                        }
                        Spacer()
                        Text("\(cameraSelectionService.selected.count)")
                            .font(.system(size: 15))
                            .padding(8)
                            .overlay(Circle()
                                .stroke(Color.white, lineWidth: 2))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                }

                HStack(spacing: 40) {
                    Button {
                        cameraViewModel.toggleFlash()
                    } label: {
                        Image(cameraViewModel.flashEnabled ? "FlashOn" : "FlashOff", bundle: .current)
                    }

                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.4), lineWidth: 6)
                            .frame(width: 72, height: 72)

                        Button {
                            cameraViewModel.takePhoto()
                        } label: {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                        }
                    }

                    Button {
                        cameraViewModel.flipCamera()
                    } label: {
                        Image("FlipCamera", bundle: .current)
                    }
                }
            }
            .padding(.top, 24)
            .padding(.bottom, safeAreaInsets.bottom + 50)
        }
        .background(theme.main.cameraBackground)
        .onEnteredBackground(perform: cameraViewModel.stopSession)
        .onEnteredForeground(perform: cameraViewModel.startSession)
        .onReceive(cameraViewModel.capturedPhotoPublisher) {
            viewModel.pickedMediaUrl = $0
            didTakePicture()
        }
    }

}