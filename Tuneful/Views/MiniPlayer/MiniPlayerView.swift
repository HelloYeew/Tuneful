//
//  ContentView.swift
//  Tuneful
//
//  Created by Martin Fekete on 27/07/2023.
//

import SwiftUI
import MediaPlayer

struct MiniPlayerView: View {
    
    @AppStorage("miniPlayerBackground") var miniPlayerBackground: BackgroundType = .albumArt
    @EnvironmentObject var playerManager: PlayerManager
    @State private var isShowingPlaybackControls = false
    
    private var imageSize: CGFloat = 140.0
    private weak var parentWindow: MiniPlayerWindow!
    
    init(parentWindow: MiniPlayerWindow) {
        self.parentWindow = parentWindow
    }

    var body: some View {
        
        ZStack {
            if miniPlayerBackground == .albumArt && playerManager.isRunning {
                Image(nsImage: playerManager.track.albumArt)
                    .resizable()
                    .scaledToFill()
                VisualEffectView(material: .popover, blendingMode: .withinWindow)
            }
            
            if !playerManager.isRunning {
                Text("Please open \(playerManager.name) to use Tuneful")
                    .foregroundColor(.primary.opacity(0.4))
                    .font(.system(size: 14, weight: .regular))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .padding(.bottom, 20)
            } else {
                HStack(spacing: 0) {
                    ZStack {
                        AlbumArtView(imageSize: self.imageSize)
                            .padding(.leading, 7)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .dragWindowWithClick()
                        
                        AddToFavoritesView()
                            .opacity(isShowingPlaybackControls ? 1 : 0)
                    }
                    .onHover { _ in
                        withAnimation(.linear(duration: 0.1)) {
                            self.isShowingPlaybackControls.toggle()
                        }
                    }
                    
                    VStack(spacing: 7) {
                        Button(action: playerManager.openMusicApp) {
                            VStack {
                                Text(playerManager.track.title)
                                    .font(.body)
                                    .bold()
                                    .lineLimit(1)
                                
                                Text(playerManager.track.artist)
                                    .font(.body)
                                    .lineLimit(1)
                            }
                        }
                        .pressButtonStyle()
                        
                        PlaybackPositionView()
                        
                        PlaybackButtonsView(playButtonSize: 15)
                        
//                        HStack(spacing: 10) {
//                            
//                            Button(action: playerManager.previousTrack){
//                                Image(systemName: "backward.end.fill")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                                    .animation(.easeInOut(duration: 2.0), value: 1)
//                            }
//                            .pressButtonStyle()
//                            
//                            PlayPauseButton(buttonSize: 35)
//                            
//                            Button(action: playerManager.nextTrack) {
//                                Image(systemName: "forward.end.fill")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                                    .animation(.easeInOut(duration: 2.0), value: 1)
//                            }
//                            .pressButtonStyle()
//                        }
                    }
                    .padding()
                    .opacity(0.8)
                }
            }
        }
        .frame(width: 310, height: 155)
        .overlay(
            NotificationView()
        )
        .if(miniPlayerBackground == .transparent || !playerManager.isRunning) { view in
            view.background(VisualEffectView(material: .underWindowBackground, blendingMode: .withinWindow))
        }
    }
}
