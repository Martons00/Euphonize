//
//  WaveformType.swift
//  TesterMC3
//
//  Created by Raffaele Martone on 18/02/23.
//

import AVFoundation

    import UIKit

    public typealias DSColor = UIColor
    public typealias DSImage = UIImage
    public enum DSScreen {
        public static var scale: CGFloat { UIScreen.main.scale }
    }

/**
 Renders the waveformsamples  on the provided `CGContext`.

 Default implementations are `LinearWaveformRenderer` and `CircularWaveformRenderer`.
 Check out those if you'd like to implement your own custom renderer.
*/
public protocol WaveformRenderer {
    /**
     Renders the waveformsamples  on the provided `CGContext`.

     - Parameters:
        - samples: `[Float]` of the amplitude envelope to be drawn, normalized to interval `(0...1)`. `0` is maximum (typically `0dB`).
        `1` is the noise floor, typically `-50dB`, as defined in `WaveformAnalyzer.noiseFloorDecibelCutoff`.
        - with configuration: The desired configuration to be used for drawing.
        - lastOffset: You can typtically leave this `0`. **Required for live rendering**, where it is needed to keep track of the last drawing cycle. Setting it avoids 'flickering' as samples are being added
         continuously and the waveform moves across the view.
     */
    func render(samples: [Float], on context: CGContext, with configuration: Waveform.Configuration, lastOffset: Int, duration: Float)
}

public enum Waveform {
    /**
     Style of the waveform which is used during drawing:
     - **filled**: Use solid color for the waveform.
     - **outlined**: Draws the envelope as an outline with the provided thickness.
     - **gradient**: Use gradient based on color for the waveform.
     - **gradientOutlined**: Use gradient based on color for the waveform. Draws the envelope as an outline with the provided thickness.
     - **striped**: Use striped filling based on color for the waveform.
     */
    public enum Style: Equatable {
        public struct StripeConfig: Equatable {
            /// Color of the waveform stripes. Default is clear.
            public let color: DSColor

            /// Width of stripes drawn. Default is `1`
            public let width: CGFloat

            /// Space between stripes. Default is `5`
            public let spacing: CGFloat

            /// Line cap style. Default is `.round`.
            public let lineCap: CGLineCap

            public init(color: DSColor, width: CGFloat = 1, spacing: CGFloat = 5, lineCap: CGLineCap = .round) {
                self.color = color
                self.width = width
                self.spacing = spacing
                self.lineCap = lineCap
            }
        }

        case filled(DSColor)
        case outlined(DSColor, CGFloat)
        case gradient([DSColor])
        case gradientOutlined([DSColor], CGFloat)
        case striped(StripeConfig)
    }

    /**
     Defines the dampening attributes of the waveform.
     */
    public struct Dampening: Equatable {
        public enum Sides: Equatable {
            case left
            case right
            case both
        }

        /// Determines the percentage of the resulting graph to be dampened.
        ///
        /// Must be within `(0..<0.5)` to leave an undapmened area.
        /// Default is `0.125`
        public let percentage: Float

        /// Determines which sides of the graph to dampen.
        /// Default is `.both`
        public let sides: Sides

        /// Easing function to be used. Default is `pow(x, 2)`.
        public let easing: (Float) -> Float

        public init(percentage: Float = 0.125, sides: Sides = .both, easing: @escaping (Float) -> Float = { x in pow(x, 2) }) {
            guard (0...0.5).contains(percentage) else {
                preconditionFailure("dampeningPercentage must be within (0..<0.5)")
            }

            self.percentage = percentage
            self.sides = sides
            self.easing = easing
        }

        /// Build a new `Waveform.Dampening` with only the given parameters replaced.
        public func with(percentage: Float? = nil, sides: Sides? = nil, easing: ((Float) -> Float)? = nil) -> Dampening {
            .init(percentage: percentage ?? self.percentage, sides: sides ?? self.sides, easing: easing ?? self.easing)
        }

        public static func == (lhs: Waveform.Dampening, rhs: Waveform.Dampening) -> Bool {
            // poor-man's way to make two closures Equatable w/o too much hassle
            let randomEqualitySample = Float.random(in: (0..<Float.greatestFiniteMagnitude))
            return lhs.percentage == rhs.percentage && lhs.sides == rhs.sides && lhs.easing(randomEqualitySample) == rhs.easing(randomEqualitySample)
        }
    }

    /// Allows customization of the waveform output image.
    public struct Configuration: Equatable {
        /// Desired output size of the waveform image, works together with scale. Default is `.zero`.
        public let size: CGSize

        /// Background color of the waveform, defaults to `clear`.
        public let backgroundColor: DSColor

        /// Waveform drawing style, defaults to `.gradient`.
        public let style: Style

        /// *Optional* Waveform dampening, defaults to `nil`.
        public let dampening: Dampening?

        /// Scale (@2x, @3x, etc.) to be applied to the image, defaults to `UIScreen.main.scale`.
        public let scale: CGFloat

        /**
         Vertical scaling factor. Default is `0.95`, leaving a small vertical padding.

         The `verticalScalingFactor` describes the maximum vertical amplitude
         of the envelope being drawn in relation to its view's (image's) size.

         * `0`: the waveform has no vertical amplitude and is just a line.
         * `1`: the waveform uses the full available vertical space.
         * `> 1`: louder waveform samples will extend out of the view boundaries and clip.
         */
        public let verticalScalingFactor: CGFloat

        /// Waveform antialiasing. If enabled, may reduce overall opacity. Default is `false`.
        public let shouldAntialias: Bool

        var shouldDampen: Bool {
            dampening != nil
        }

        public init(size: CGSize = .zero,
                    backgroundColor: DSColor = DSColor.clear,
                    style: Style = .gradient([DSColor.white, DSColor.black]),
                    dampening: Dampening? = nil,
                    scale: CGFloat = DSScreen.scale,
                    verticalScalingFactor: CGFloat = 0.95,
                    shouldAntialias: Bool = false) {
            guard verticalScalingFactor > 0 else {
                preconditionFailure("verticalScalingFactor must be greater 0")
            }

            self.backgroundColor = backgroundColor
            self.style = style
            self.dampening = dampening
            self.size = size
            self.scale = scale
            self.verticalScalingFactor = verticalScalingFactor
            self.shouldAntialias = shouldAntialias
        }

        /// Build a new `Waveform.Configuration` with only the given parameters replaced.
        public func with(size: CGSize? = nil,
                         backgroundColor: DSColor? = nil,
                         style: Style? = nil,
                         dampening: Dampening? = nil,
                         scale: CGFloat? = nil,
                         verticalScalingFactor: CGFloat? = nil,
                         shouldAntialias: Bool? = nil
        ) -> Configuration {
            Configuration(
                size: size ?? self.size,
                backgroundColor: backgroundColor ?? self.backgroundColor,
                style: style ?? self.style,
                dampening: dampening ?? self.dampening,
                scale: scale ?? self.scale,
                verticalScalingFactor: verticalScalingFactor ?? self.verticalScalingFactor,
                shouldAntialias: shouldAntialias ?? self.shouldAntialias
            )
        }
    }
}
