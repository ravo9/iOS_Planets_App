import UIKit

class PlanetViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var climateLabel: UILabel!
    @IBOutlet var terrainLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    
    var verticalMargin = 14.0
    var horizontalMargin = 10.0
    
    static let identifier = Constants.planetViewCellIdentifier
    
    static func nib() -> UINib {
        return UINib(nibName: Constants.planetViewCellIdentifier, bundle: nil)
    }
    
    public func configure(with planet: PlanetModel) {
        self.nameLabel.text = planet.name
        self.climateLabel.text = planet.climate
        self.terrainLabel.text = planet.terrain
        self.populationLabel.text = planet.population
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: verticalMargin,
            left: horizontalMargin,
            bottom: verticalMargin,
            right: horizontalMargin
        ))
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
