//
//  ValidationError.swift
//
//  Created by MGAbouarab®
//

import Foundation

enum ValidationError: Error {
    
    //MARK: - Name -
    case emptyFirstName
    case shortFirstName
    case longFirstName
    case emptyLastName
    case shortLastName
    case longLastName
    case emptyFamilyName
    case shortFamilyName
    case longFamilyName
    case emptyFullName
    case shortFullName
    case longFullName
    case emptyName
    case shortName
    case longName
    case emptyUsername
    
    //MARK: - Phone -
    case emptyPhoneNumber
    case incorrectPhoneNumber
    case incorrectWhatsAppNumber
    
    //MARK: - Verification Code -
    case emptyVerificationCode
    case incorrectVerificationCode
    
    //MARK: - Email -
    case emptyMail
    case wrongMail
    
    //MARK: - Passwords -
    case emptyPassword
    case shortPassword
    case emptyNewPassword
    case shortNewPassword
    case emptyOldPassword
    case shortOldPassword
    case emptyConfirmNewPassword
    case emptyConfirmPassword
    case notMatchPasswords
    case terms
    case emptyCurrentPassword
    
    //MARK: - Locations -
    case emptyCountry
    case emptyGovernorate
    case emptyCity
    case floorNumbers
    case emptyArea
    case emptyStreet
    case addressType
    case emptyLocation
    case estateLocation
    case emptyAddressDetails
    case emptyAddress
    case emptyBuildingNum
    //MARK: - Images -
    case coverPicture
    case profilePicture
    case licensePicture
    case productPicture
    case contractNumber
    
    //MARK: - carPlate -
    case carPicture
    case carPlate
    case invalidCarPlate
    case carModel
    case carType
    
    //MARK: - Date -
    case emptyAge
    case youngAge
    case emptyDate
    case notOldDate
    case notNewDate
    case emptyTime
    //MARK: - Message -
    case emptyTitle
    case emptyMessage
    case emptySubject
    case emptyTitleType
    case emptyContactReason
    //MARK: - Bank -
    case bankAccountHolder
    case bankName
    case bankTransferImage
    case fromBankName
    case bankAccountNumber
    
    //MARK: - category -
    case emptyCategory
    case emptyPriceBefore
    case emptyPriceAfter
    case priceBeforeSmallThanPriceAfter
    case emptyDescription
    case iban
    case invalidSaudiIBAN
    
    //MARK: - Terms and condition -
    case uncheckedTerms
    
    //MARK: - Restart -
    case restartApp
    
    //MARK: - OTP Verification -
    case emptyOTP
    case incorrectOTP
    
    //MARK: - Empty Fields -
    case unSelectedItem
    case unSelectedService
    case unselectedLanguage
    case emptyAddressTitle
    case emptyAddressDescription
    case emptyProductType
    case emptySpecifications
    case emptyRequiredQuantity
    case emptyPaymentMethod
    
    //MARK: - Wallet -
    case emptyAmount
    case invalidAmount
    case withdrawAmount
    
    //MARK: - Gender -
    case unselectedGender
    
    //MARK: - Complaint -
    case emptyComplaintTitle
    case emptyComplaintDetails
    case emptyComplaintReason
    
    //MARK: - Notes -
    case emptyNotes
    
    //MARK: - Empty Reason -
    case emptyReason
    
    //MARK: - Rating -
    case emptyRatingStars
    case emptyRatingcomment

    //MARK: - Signup -
    case emptyIdentityNumber
    case emptyVehicleSerialNumber
    case invalidVehicleSerialNumber
    case emptyDelegateCompany
    case emptyProvider
    case emptyDriverIdentityImage
    case emptyDriverIdentityEndDate
    case emptyVehicleOperatingLicenseImage
    case emptyVehicleOperatingLicenseEndDate
    case emptyNationalIdentityImage
    case emptyIdentityImageEndDate
    case emptyVehicleRegistrationImage
    case emptyVehicleRegistrationLicenseDate
    case emptyDrivingLicenseImage
    case emptyDrivingLicenseEndDate
    case emptyVehicleInsuranceImage
    case emptyVehicleInsuranceEndDate
    case emptyPeriodicCheckUpImage
    case emptyPeriodicCheckUpDate
    case emptyOtherImage
    case emptyVehicleFrontImage
    case emptyVehicleBackImage
    case emptyVehicleRightImage
    case emptyVehicleLeftImage

    //MARK: - Provider Signup -
    case emptyStoreName
    case shortStoreName
    case longStoreName
    case emptyCommercialNumber
    case emptyCommercialImage
    case emptyPermissionImage
    case emptyProviderIdentityImage
    case emptyPermissionEndDate
    case emptyCommercialEndDate
    case emptyTaxNumber
    case emptyEstablishmentName

    //MARK: - Upload -
    case imageUploadInProgress
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        
        switch self {
            //MARK: - Name -
        case .emptyFirstName:
            return "Please enter first name.".validationLocalized
        case .shortFirstName:
            return "First name is too short.".validationLocalized
        case .longFirstName:
            return "First name is too long.".validationLocalized
        case .emptyLastName:
            return "Please enter last name.".validationLocalized
        case .shortLastName:
            return "Last name is too short.".validationLocalized
        case .longLastName:
            return "Last name is too long.".validationLocalized
        case .emptyFamilyName:
            return "Please enter family name.".validationLocalized
        case .shortFamilyName:
            return "Family name is too short.".validationLocalized
        case .longFamilyName:
            return "Family name is too long.".validationLocalized
        case .emptyFullName:
            return "Please enter full name.".validationLocalized
        case .shortFullName:
            return "Full name is too short.".validationLocalized
        case .longFullName:
            return "Full name is too long.".validationLocalized
        case .emptyName:
            return "Please enter name.".validationLocalized
        case .shortName:
            return "Name is too short.".validationLocalized
        case .longName:
            return "Name is too long.".validationLocalized
        case .emptyUsername:
            return "please_enter_username".validationLocalized
            
            //MARK: - Phone -
        case .emptyPhoneNumber:
            return "Please enter your phone number.".validationLocalized
        case .incorrectPhoneNumber:
            return "invalid_saudi_phone".validationLocalized
            
        case .incorrectWhatsAppNumber:
            return "Please enter correct whatsApp number.".validationLocalized
            
            //MARK: - Verification Code -
        case .emptyVerificationCode:
            return "Please enter verification code".validationLocalized
        case .incorrectVerificationCode:
            return "Verification Code should be 4 digits.".validationLocalized
        case .estateLocation:
            return "Please enter estate location".validationLocalized
        case .contractNumber:
            return "Please enter contract number".validationLocalized
            //MARK: - Email -
        case .emptyMail:
            return "Please enter email field.".validationLocalized
        case .wrongMail:
            return "Please enter correct email address.".validationLocalized
            
            //MARK: - Passwords -
        case .emptyPassword:
            return "Please enter password field.".validationLocalized
        case .shortPassword:
            return "Password is too short, it should be 6 characters at least.".validationLocalized
        case .emptyNewPassword:
            return "Please enter new password field.".validationLocalized
        case .shortNewPassword:
            return "New password is too short, it should be 6 characters at least.".validationLocalized
        case .emptyOldPassword:
            return "Please enter old password field.".validationLocalized
        case .shortOldPassword:
            return "Old password is too short, it should be 6 characters at least.".validationLocalized
        case .emptyConfirmNewPassword:
            return "Please enter confirm new password field.".validationLocalized
        case .emptyConfirmPassword:
            return "Please enter confirm password field.".validationLocalized
        case .notMatchPasswords:
            return "passwords_do_not_match".validationLocalized
        case .terms:
            return "Please read and agree our terms and conditions first".validationLocalized
        case .emptyCurrentPassword:
            return "empty_current_password".validationLocalized
            //MARK: - Locations -
        case .emptyCountry:
            return "Please select country.".validationLocalized
        case .emptyGovernorate:
            return "Please select governorate".validationLocalized
        case .emptyCity:
            return "Please select city.".validationLocalized
        case .floorNumbers:
            return "Please select the floor".validationLocalized
        case .emptyArea:
            return "Please select area.".validationLocalized
        case .emptyStreet:
            return "Please enter street name.".validationLocalized
        case .addressType:
            return "Please enter address type.".validationLocalized
        case .emptyLocation:
            return "Please select the location.".validationLocalized
        case .emptyAddressDetails:
            return "Please write address details".validationLocalized
        case .emptyAddress:
            return "Please enter address name".validationLocalized
        case .emptyBuildingNum:
            return "Please enter building number".validationLocalized

            //MARK: - Images -
        case .coverPicture:
            return "Please pick cover picture.".validationLocalized
        case .profilePicture:
            return "Please pick your profile picture.".validationLocalized
        case .licensePicture:
            return "Please pick license picture.".validationLocalized
        case .productPicture:
            return "Please pick product image.".validationLocalized
            
            //MARK: - Cars -
        case .carPicture:
            return "Please pick car picture".validationLocalized
        case .carPlate:
            return "Please enter car plate number.".validationLocalized
        case .invalidCarPlate:
            return "invalid_car_plate".validationLocalized
        case .carModel:
            return "Please select car model.".validationLocalized
        case .carType:
            return "Please Select car type.".validationLocalized
            
            //MARK: - Date -
        case .emptyAge:
            return "Please enter the age.".validationLocalized
        case .youngAge:
            return "If it is your age, please grow up first =D.".validationLocalized
        case .notOldDate:
            return "Please select older date.".validationLocalized
        case .notNewDate:
            return "Please select newer date.".validationLocalized
        case .emptyDate:
            return "Please choose a time to continue".validationLocalized
            
        case .emptyTime:
            return "Please select the time.".validationLocalized
            
            //MARK: - Message -
        case .emptyTitle:
            return "Please enter message title".validationLocalized
        case .emptyMessage:
            return "Please enter your message".validationLocalized
        case .emptySubject:
            return "Please enter message subject".validationLocalized
        case .emptyTitleType:
            return "Please enter title type".validationLocalized
        case .emptyContactReason:
            return "Please choose contact reason".validationLocalized
            
            //MARK: - Bank -
        case .bankAccountHolder:
            return "Please enter bank account holder name".validationLocalized
        case .bankName:
            return "Please enter bank name".validationLocalized
        case .bankTransferImage:
            return "Please select bank transfer image".validationLocalized
        case .fromBankName:
            return "Please enter from bank name".validationLocalized
        case .bankAccountNumber:
            return "Please enter bank account number".validationLocalized
        case .iban:
            return "Please enter IBAN number".validationLocalized
        case .invalidSaudiIBAN:
            return "invalid_saudi_iban".validationLocalized
            
            //MARK: - category -
        case .emptyCategory:
            return "Please Select category".validationLocalized
        case .emptyPriceBefore:
            return "Please enter price before".validationLocalized
        case .emptyPriceAfter:
            return "Please enter price after".validationLocalized
        case .priceBeforeSmallThanPriceAfter:
            return "price before is smaller than price after".validationLocalized
        case .emptyDescription:
            return "Please enter description".validationLocalized
            
            
            //MARK: - Terms and condition -
        case .uncheckedTerms:
            return "Please accept terms and conditions to continue.".localized
            
            //MARK: - Restart -
        case .restartApp:
            return "Please restart the app to apply language changes.".localized
            
            //MARK: - OTP Verification -
        case .emptyOTP:
            return "Please enter OTP number to continue.".localized
        case .incorrectOTP:
            return "OTP verification failed. Please Try again.".localized
            
            
            //MARK: - Empty Fields -
        case .unSelectedItem:
            return "Please choose to continue.".localized
            
        case .unselectedLanguage:
            return "Please select a language to continue".validationLocalized
            
        case .emptyAddressTitle:
            return "Please enter address title".localized
        case .emptyAddressDescription:
            return "Please enter address description".localized
            
        case .unSelectedService:
            return "Please select a service.".validationLocalized
            
        case .emptyProductType:
            return "empty_product_type".validationLocalized

        case .emptySpecifications:
            return "empty_product_specifications".validationLocalized

        case .emptyRequiredQuantity:
            return "empty_required_quantity".validationLocalized
            
        case .emptyPaymentMethod:
            return "empty_payment_method".validationLocalized
            
            //MARK: - Wallet -
            
        case .emptyAmount:
            return "emptyAmount".validationLocalized
            
        case .invalidAmount:
            return "invalidAmount".validationLocalized
            
        case .withdrawAmount:
            return "withdrawAmount".validationLocalized

            //MARK: - Gender -
        case .unselectedGender:
            return "Please select a gender".validationLocalized
            
            //MARK: - Complaint -
        case .emptyComplaintTitle:
            return "Please enter complaint title".validationLocalized
            
        case .emptyComplaintDetails:
            return "Please enter complaint details".validationLocalized
    
        case .emptyComplaintReason:
            return "enter_complaint_reason".validationLocalized
            
            //MARK: - Notes -
        case .emptyNotes:
            return "Please enter your notes to continue".validationLocalized
            
            //MARK: - Empty Reason -
        case .emptyReason:
            return "Please enter reason to continue".validationLocalized
            
            //MARK: -  Rating -
        case .emptyRatingStars:
            return "empty_rating_stars".validationLocalized
        case .emptyRatingcomment:
            return "empty_rating_comment".validationLocalized

            //MARK: - Signup -
        case .emptyIdentityNumber:
            return "empty_identity_number".validationLocalized
        case .emptyVehicleSerialNumber:
            return "empty_vehicle_serial_number".validationLocalized
        case .invalidVehicleSerialNumber:
            return "invalid_vehicle_serial_number".validationLocalized
        case .emptyDelegateCompany:
            return "empty_delegate_company".validationLocalized
        case .emptyProvider:
            return "empty_provider".validationLocalized
        case .emptyDriverIdentityImage:
            return "empty_driver_identity_image".validationLocalized
        case .emptyDriverIdentityEndDate:
            return "empty_driver_identity_end_date".validationLocalized
        case .emptyVehicleOperatingLicenseImage:
            return "empty_vehicle_operating_license_image".validationLocalized
        case .emptyVehicleOperatingLicenseEndDate:
            return "empty_vehicle_operating_license_end_date".validationLocalized
        case .emptyNationalIdentityImage:
            return "empty_national_identity_image".validationLocalized
        case .emptyIdentityImageEndDate:
            return "empty_identity_image_end_date".validationLocalized
        case .emptyVehicleRegistrationImage:
            return "empty_vehicle_registration_image".validationLocalized
        case .emptyVehicleRegistrationLicenseDate:
            return "empty_vehicle_registration_license_date".validationLocalized
        case .emptyDrivingLicenseImage:
            return "empty_driving_license_image".validationLocalized
        case .emptyDrivingLicenseEndDate:
            return "empty_driving_license_end_date".validationLocalized
        case .emptyVehicleInsuranceImage:
            return "empty_vehicle_insurance_image".validationLocalized
        case .emptyVehicleInsuranceEndDate:
            return "empty_vehicle_insurance_end_date".validationLocalized
        case .emptyPeriodicCheckUpImage:
            return "empty_periodic_check_up_image".validationLocalized
        case .emptyPeriodicCheckUpDate:
            return "empty_periodic_check_up_date".validationLocalized
        case .emptyOtherImage:
            return "empty_other_image".validationLocalized
        case .emptyVehicleFrontImage:
            return "empty_vehicle_front_image".validationLocalized
        case .emptyVehicleBackImage:
            return "empty_vehicle_back_image".validationLocalized
        case .emptyVehicleRightImage:
            return "empty_vehicle_right_image".validationLocalized
        case .emptyVehicleLeftImage:
            return "empty_vehicle_left_image".validationLocalized

            //MARK: - Provider Signup -
        case .emptyStoreName:
            return "empty_store_name".validationLocalized
        case .shortStoreName:
            return "short_store_name".validationLocalized
        case .longStoreName:
            return "long_store_name".validationLocalized
        case .emptyCommercialNumber:
            return "empty_commercial_number".validationLocalized
        case .emptyCommercialImage:
            return "empty_commercial_image".validationLocalized
        case .emptyPermissionImage:
            return "empty_permission_image".validationLocalized
        case .emptyProviderIdentityImage:
            return "empty_provider_identity_image".validationLocalized
        case .emptyPermissionEndDate:
            return "empty_permission_end_date".validationLocalized
        case .emptyCommercialEndDate:
            return "empty_commercial_end_date".validationLocalized
        case .emptyTaxNumber:
            return "empty_tax_number".validationLocalized
        case .emptyEstablishmentName:
            return "empty_establishment_name".validationLocalized
        case .imageUploadInProgress:
            return "image_upload_in_progress".validationLocalized
        }
    }
}

