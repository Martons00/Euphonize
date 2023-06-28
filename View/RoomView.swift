//
//  RoomView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 27/06/23.
//

import SwiftUI

struct RoomView: View {
    @Binding var screens : Screens
    @Binding var rooms : Rooms
    @State var RecordingModalIsPresented = false
    @State var SaveAlertIsPresented = false
    @State private var recordingName = ""
    @State var TimerModalIsPresented = false
    let audioPlayer = AudioPlayer.shared
    @ObservedObject var audioRecorder = AudioRecorder()
    let roomName : String
    var ns: Namespace.ID
    @State var selectedInterval = 30
    
    @State var currentAudio : Int = 0
    
    init(screens: Binding<Screens>, rooms: Binding<Rooms>, audioRecorder: AudioRecorder = AudioRecorder(), roomName: String, ns: Namespace.ID) {
        self._screens = screens
        self._rooms = rooms
        self.audioRecorder = audioRecorder
        self.roomName = roomName
        self.ns = ns
        
        self.audioRecorder.setRoomName(name: roomName)
    }
    
    
    var recordings: [Recording] {
        return [
            Recording(fileURL: Bundle.main.url(forResource: roomName + "1", withExtension: ".mp3")!, createdAt: .now, name: roomName + "1"),
            Recording(fileURL: Bundle.main.url(forResource: roomName + "2", withExtension: ".mp3")!, createdAt: .now, name: roomName + "2"),
            Recording(fileURL: Bundle.main.url(forResource: roomName + "3", withExtension: ".mp3")!, createdAt: .now, name: roomName + "3")
        ] + audioRecorder.recordings 
    }
    
    
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                CustomTopBarNavigationView(screens: $screens, roomName: roomName, RecordingModalIsPresented: $RecordingModalIsPresented)
                AnimationLobbyView(rooms: $rooms, ns: ns)
                    .frame(width: geo.size.width,height: geo.size.height * 0.4)
                    .foregroundColor(.black)
                
                AudioListRoomView(room: roomName, currentAudio : $currentAudio)
                    .frame(width: geo.size.width * 0.9 ,height: geo.size.height * 0.2)
                    .padding()
                Spacer()
                PlayerView(TimerModalIsPresented: $TimerModalIsPresented, audio: $currentAudio, audioRecorder: audioRecorder ,roomName: roomName)
                    .frame(width: geo.size.width * 0.9 ,height: geo.size.height * 0.15)
                    .padding()
            }
            .sheet(isPresented: $TimerModalIsPresented){
                
                if #available(iOS 16.0, *) {
                    TimerModal(selectedInterval: $selectedInterval, TimerModalIsPresented: $TimerModalIsPresented,audioRecorder: audioRecorder, audio: $currentAudio,roomName: roomName)
                    
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .presentationDetents([.medium])
                    
                }else{
                        TimerModal(selectedInterval: $selectedInterval, TimerModalIsPresented: $TimerModalIsPresented,audioRecorder: audioRecorder, audio: $currentAudio,roomName: roomName)
                        
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            
            .sheet(isPresented:
                    $RecordingModalIsPresented){
                if #available(iOS 16.0, *) {
                RecordingModal(audioRecorder: audioRecorder, recordingName: $recordingName, SaveAlertIsPresented: $SaveAlertIsPresented)
                    .alert(NSLocalizedString(".NameYourSound", comment: ""),isPresented: $SaveAlertIsPresented) {
                        SaveAlert(audioRecorder: audioRecorder, recordingName: $recordingName, SaveAlertIsPresented: $SaveAlertIsPresented)
                    }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .presentationDetents([.medium])
                } else {
                       RecordingModal(audioRecorder: audioRecorder, recordingName: $recordingName, SaveAlertIsPresented: $SaveAlertIsPresented)
                           .alert(NSLocalizedString("Name your recording", comment: ""),isPresented: $SaveAlertIsPresented) {
                               SaveAlert(audioRecorder: audioRecorder, recordingName: $recordingName, SaveAlertIsPresented: $SaveAlertIsPresented)
                           }
                       
                       .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(screens: .constant(.main), rooms: .constant(.relax), roomName: "Relax", ns: Namespace.init().wrappedValue)
    }
}
