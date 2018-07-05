import UIKit

class DepositViewController: UIViewController {

    @IBOutlet weak var avatarImageView: AvatarImageView!
    @IBOutlet weak var qrcodeAvatarImageView: AvatarImageView!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var identifyNumberLabel: UILabel!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var blockchainImageView: CornerImageView!
    @IBOutlet weak var normalAssetView: UIView!
    @IBOutlet weak var accountAssetView: UIView!
    @IBOutlet weak var accountConfirmationLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountMemoLabel: UILabel!
    
    private var asset: AssetItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        container?.subtitleLabel.text = asset.symbol
        container?.subtitleLabel.isHidden = false

        view.layoutIfNeeded()

        asset.accountName = "mengbilaomao"
        asset.accountMemo = "4001243559"

        if asset.isAccount, let accountName = asset.accountName, let accountMemo = asset.accountMemo {
            accountNameLabel.text = accountName
            accountMemoLabel.text = accountMemo
            normalAssetView.isHidden = true
            accountAssetView.isHidden = false
            confirmationLabel.isHidden = true
            accountConfirmationLabel.isHidden = false
            accountConfirmationLabel.text = Localized.WALLET_DEPOSIT_CONFIRMATIONS(confirmations: asset.confirmations)
        } else {
            if !asset.publicKey.isEmpty {
                qrcodeImageView.image = UIImage(qrcode: asset.publicKey, size: qrcodeImageView.frame.size)
                addressButton.setTitle(asset.publicKey, for: .normal)
            }
            confirmationLabel.text = Localized.WALLET_DEPOSIT_CONFIRMATIONS(confirmations: asset.confirmations)
            qrcodeAvatarImageView.sd_setImage(with: URL(string: asset.iconUrl), placeholderImage: #imageLiteral(resourceName: "ic_place_holder"))
            qrcodeAvatarImageView.layer.borderColor = UIColor.white.cgColor
            qrcodeAvatarImageView.layer.borderWidth = 2
            if let chainIconUrl = asset.chainIconUrl {
                blockchainImageView.sd_setImage(with: URL(string: chainIconUrl))
                blockchainImageView.isHidden = false
            } else {
                blockchainImageView.isHidden = true
            }
            normalAssetView.isHidden = false
            accountAssetView.isHidden = true
            confirmationLabel.isHidden = false
            accountConfirmationLabel.isHidden = true
        }

        if let account = AccountAPI.shared.account {
            avatarImageView.setImage(with: account)
            fullNameLabel.text = account.full_name
            identifyNumberLabel.text = Localized.PROFILE_MIXIN_ID(id: account.identity_number)
        }
    }

    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = asset.publicKey
        NotificationCenter.default.postOnMain(name: .ToastMessageDidAppear, object: Localized.TOAST_COPIED)
    }

    @IBAction func copyAccountNameAction(_ sender: Any) {

    }

    @IBAction func copyAccountMemoAction(_ sender: Any) {

    }

    class func instance(asset: AssetItem) -> UIViewController {
        let vc = Storyboard.wallet.instantiateViewController(withIdentifier: "deposit") as! DepositViewController
        vc.asset = asset
        return ContainerViewController.instance(viewController: vc, title: Localized.WALLET_DEPOSIT)
    }
}
