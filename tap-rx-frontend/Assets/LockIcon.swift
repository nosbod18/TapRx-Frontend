//
//  LockIcon.swift
//  tap-rx-frontend
//
//  Created by Drew Clutes on 2/1/24.
//

import SwiftUI

struct LockIcon: View {
    var body: some View {
        ZStack {
            Image(systemName: "lock.fill").resizable().frame(width:70,height: 90).foregroundStyle(Color.medicalRed).bold().offset(x:-11)
            Image(systemName: "key.fill").resizable().frame(width: 50,height: 100).foregroundStyle(Color.medicalDarkBlue).offset(x:21,y:-5)
        }
    }
}

#Preview {
    LockIcon()
}
