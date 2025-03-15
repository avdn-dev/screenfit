//
//  SkeletonView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct SkeletonView: View {
    var poseEstimator: PoseEstimator
    var size: CGSize
    
    var body: some View {
        if !poseEstimator.bodyParts.isEmpty {
            ZStack {
                // Right leg
                Skeleton(points: [poseEstimator.bodyParts[.rightAnkle]?.location, poseEstimator.bodyParts[.rightKnee]?.location, poseEstimator.bodyParts[.rightHip]?.location,
                                  poseEstimator.bodyParts[.root]?.location].compactMap { $0 }, size: size)
                .stroke(lineWidth: 5.0)
                .fill(.accent)
                
                // Left leg
                Skeleton(points: [poseEstimator.bodyParts[.leftAnkle]?.location, poseEstimator.bodyParts[.leftKnee]?.location, poseEstimator.bodyParts[.leftHip]?.location,
                                  poseEstimator.bodyParts[.root]?.location].compactMap { $0 }, size: size)
                .stroke(lineWidth: 5.0)
                .fill(.accent)
                
                // Right arm
                Skeleton(points: [poseEstimator.bodyParts[.rightWrist]?.location, poseEstimator.bodyParts[.rightElbow]?.location, poseEstimator.bodyParts[.rightShoulder]?.location, poseEstimator.bodyParts[.neck]?.location].compactMap { $0 }, size: size)
                    .stroke(lineWidth: 5.0)
                    .fill(.accent)
                
                // Left arm
                Skeleton(points: [poseEstimator.bodyParts[.leftWrist]?.location, poseEstimator.bodyParts[.leftElbow]?.location, poseEstimator.bodyParts[.leftShoulder]?.location, poseEstimator.bodyParts[.neck]?.location].compactMap { $0 }, size: size)
                    .stroke(lineWidth: 5.0)
                    .fill(.accent)
                
                // Root to nose
                Skeleton(points: [poseEstimator.bodyParts[.root]?.location,
                                  poseEstimator.bodyParts[.neck]?.location,  poseEstimator.bodyParts[.nose]?.location].compactMap { $0 }, size: size)
                .stroke(lineWidth: 5.0)
                .fill(.accent)
            }
        }
    }
}
