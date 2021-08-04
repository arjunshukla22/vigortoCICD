/*
 * Reactions
 *
 * Copyright 2016-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

/// Default implementation of the facebook reactions.
extension Reaction {
  /// Struct which defines the standard facebook reactions.
  public struct facebook {
    /// The facebook's "like" reaction.
    public static var like: Reaction {
      return reactionWithId("like")
    }

    /// The facebook's "love" reaction.
    public static var love: Reaction {
      return reactionWithId("love")
    }
    /// The facebook's "care" reaction.
    public static var care: Reaction {
      return reactionWithId("care")
    }

    /// The facebook's "haha" reaction.
    public static var haha: Reaction {
      return reactionWithId("haha")
    }
    /// The facebook's "surprised" reaction.
    public static var surprise: Reaction {
      return reactionWithId("surprise")
    }
    /// The facebook's "wow" reaction.
    public static var wow: Reaction {
      return reactionWithId("wow")
    }

    /// The facebook's "sad" reaction.
    public static var sad: Reaction {
      return reactionWithId("sad")
    }

    /// The facebook's "angry" reaction.
    public static var angry: Reaction {
      return reactionWithId("angry")
    }
   

    /// The list of standard facebook reactions in this order: `.like`, `.love`, `.haha`, `.wow`, `.sad`, `.angry`.
    public static let all: [Reaction] = [facebook.like, facebook.love,facebook.care,facebook.haha,facebook.surprise, facebook.sad, facebook.wow, facebook.angry]
    public static let few: [Reaction] = [facebook.like, facebook.love]

    // MARK: - Convenience Methods

    private static func reactionWithId(_ id: String) -> Reaction {
      var color: UIColor            = .black
      var alternativeIcon: UIImage? = nil
      var selectedEmoji = 0
      switch id {
      case "like":
        selectedEmoji = 1
      //  print(id)
      //  print("selected emoji like")
        color           = UIColor(red: 0.29, green: 0.54, blue: 0.95, alpha: 1)
        alternativeIcon = imageWithName("like-template").withRenderingMode(.alwaysTemplate)
      case "love":
        print(id)
        selectedEmoji = 2
      //  print("selected emoji love")
        color = UIColor(red: 0.93, green: 0.23, blue: 0.33, alpha: 1)
      case "angry":
       // print(id)
        color = UIColor(red: 0.96, green: 0.37, blue: 0.34, alpha: 1)
      default:
        color = UIColor(red: 0.99, green: 0.84, blue: 0.38, alpha: 1)
      }

      return Reaction(id: id, title: id.localized(from: "FacebookReactionLocalizable"), color: color, icon: imageWithName(id), alternativeIcon: alternativeIcon)
    }

    private static func imageWithName(_ name: String) -> UIImage {
      return UIImage(named: name, in: .reactionsBundle(), compatibleWith: nil)!
    }
  }
}
