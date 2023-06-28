//
//  AudioListRoomView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct AudioListRoomView: View {
    @State private var searchText = ""
    
    @Binding var currentAudio : Int
    let player = EuphoManager.shared
    @ObservedObject var audioRecorder : AudioRecorder
    let room : String
    
    init(room: String, currentAudio : Binding<Int>) {
        self.audioRecorder = AudioRecorder()
        self.room = room
        self._currentAudio = currentAudio
        
        self.audioRecorder.setRoomName(name: room)
    }
    
    var recordings: [Recording] {
        if searchText == "" {
            return [
                Recording(fileURL: Bundle.main.url(forResource: room + "1", withExtension: ".mp3")!, createdAt: Date(), name: room + "1"),
                Recording(fileURL: Bundle.main.url(forResource: room + "2", withExtension: ".mp3")!, createdAt: Date(), name: room + "2"),
                Recording(fileURL: Bundle.main.url(forResource: room + "3", withExtension: ".mp3")!, createdAt: Date(), name: room + "3")
            ] + audioRecorder.recordings  
        } else {
            return audioRecorder.recordings.filter { record in
                record.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack{
            List{
                    ForEach(Array(recordings.enumerated()), id: \.element) { index , recording in
                    Button(action: {
                        currentAudio = index
                        player.startPlaying(recording: recordings[currentAudio])
                    }){
                        ZStack {
                            Color("ButtonTopColor").ignoresSafeArea()
                            HStack{
                                Text("\((((recording.name.replacingOccurrences(of: room + ".", with: "")) as NSString).deletingPathExtension))")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                            }.padding(.horizontal)
                        }
                    }.padding(.vertical,-4).padding(.horizontal,-20)
                }
                .onDelete(perform: delete)
            }.padding(.vertical)
            .searchable(text: $searchText)
            .listStyle(.plain)
        }
        .background(){
            ZStack{
                Color("ButtonTopColor")
            }
            .cornerRadius(10)
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}



struct AudioListRoomView_Previews: PreviewProvider {
    static var previews: some View {
        AudioListRoomView(room: "Relax", currentAudio: .constant(0))
    }
}
