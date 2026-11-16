//
//  ValidationService.swift
//
//  Created by MGAbouarab®
//


import Foundation

struct ValidationService {
    
    //MARK: - Name -
    static func validate(firstName: String?) throws -> String {
        guard let firstName = firstName, !firstName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyFirstName
        }
        guard firstName.count > 1 else {
            throw ValidationError.shortFirstName
        }
        guard firstName.count < 61 else {
            throw ValidationError.longFirstName
        }
        return firstName
    }
    static func validate(lastName: String?) throws -> String {
        guard let lastName = lastName, !lastName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyLastName
        }
        guard lastName.count > 1 else {
            throw ValidationError.shortLastName
        }
        guard lastName.count < 61 else {
            throw ValidationError.longLastName
        }
        return lastName
    }
    static func validate(familyName: String?) throws -> String {
        guard let familyName = familyName, !familyName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyFamilyName
        }
        guard familyName.count > 1 else {
            throw ValidationError.shortFamilyName
        }
        guard familyName.count < 61 else {
            throw ValidationError.longFamilyName
        }
        return familyName
    }
    
    @discardableResult
    static func validate(fullName: String?) throws -> String {
        guard let fullName = fullName, !fullName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyFullName
        }
        guard fullName.count > 1 else {
            throw ValidationError.shortFullName
        }
        guard fullName.count < 61 else {
            throw ValidationError.longFullName
        }
        return fullName
    }
    
    static func validate(name: String?)  throws -> String {
        
        guard let name = name, !name.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyName
        }
        
        guard name.count > 1 else {
            throw ValidationError.shortName
        }
        
        guard name.count < 61 else {
            throw ValidationError.longName
        }
        
        return  name
    }
    
    //MARK: - Phone -
    
    static func validate(phone: String?) throws -> String  {
        guard let phone = phone?.trimWhiteSpace(), !phone.isEmpty else {
            throw ValidationError.emptyPhoneNumber
        }
        
        guard phone.isValidPhoneNumber(pattern: RegularExpression.saudiArabiaPhone.value) else {
            throw ValidationError.incorrectPhoneNumber
        }
        return phone
    }
    
    
    //MARK: - Verification code -
    
    static func validate(verificationCode: String?) throws -> String {
        
        guard let code = verificationCode?.trimWhiteSpace(), !code.isEmpty else {
            throw ValidationError.emptyVerificationCode
        }
        
        guard code.count == 4 else {
            throw ValidationError.incorrectVerificationCode
        }
        return code
    }
    
    
    //MARK: - Email -
    static func validate(email: String?) throws -> String {
        guard let email = email, !email.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyMail
        }
        guard email.isValidEmail() else {
            throw ValidationError.wrongMail
        }
        return email
    }
    
    //MARK: - Passwords -
    
    static func validate(password: String?)  throws -> String  {
        
        guard let password = password?.trimWhiteSpace(), !password.isEmpty else {
            throw ValidationError.emptyPassword
        }
        
        guard password.count > 5 else {
            throw ValidationError.shortPassword
        }
        
        return password
    }
    
    static func validate(newPassword: String?) throws -> String {
        guard let newPassword = newPassword, !newPassword.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyNewPassword
        }
        guard newPassword.count > 5 else {
            throw ValidationError.shortNewPassword
        }
        return newPassword
    }
    
    static func validate(oldPassword: String?)  throws -> String   {
        guard let oldPassword = oldPassword, !oldPassword.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyOldPassword
        }
        guard oldPassword.count > 5 else {
            throw ValidationError.shortOldPassword
        }
        return oldPassword
    }
    
    static func validate(newPassword: String?,
                         confirmPassword: String?) throws -> String  {
        
        guard let newPassword = newPassword?.trimWhiteSpace(),
              !newPassword.isEmpty else {
            throw ValidationError.emptyPassword
        }
        
        guard let confirmPassword = confirmPassword?.trimWhiteSpace(),
              !confirmPassword.isEmpty else {
            throw ValidationError.emptyConfirmPassword
        }
        
        guard newPassword == confirmPassword else {
            throw ValidationError.notMatchPasswords
        }
        
        return newPassword
    }
    
    
    static func validate(newPassword: String, confirmPassword: String?) throws -> String {
        guard let confirmPassword = confirmPassword, !confirmPassword.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyConfirmPassword
        }
        guard newPassword == confirmPassword else {
            throw ValidationError.notMatchPasswords
        }
        return newPassword
    }
    
    static func validate(termesAgreed: Bool) throws {
        guard termesAgreed else {
            throw ValidationError.terms
        }
    }
    
    //MARK: - Location -
    static func validate(countryId: Int?) throws -> Int {
        guard let countryId = countryId else {
            throw ValidationError.emptyCountry
        }
        return countryId
    }
    static func validate(governorateId: Int?) throws -> Int {
        guard let governorateId = governorateId else {
            throw ValidationError.emptyGovernorate
        }
        return governorateId
    }
    static func validate(cityId: Int?) throws -> Int {
        guard let cityId = cityId else {
            throw ValidationError.emptyCity
        }
        return cityId
    }
    static func validate(areaId: Int?) throws -> Int {
        guard let areaId = areaId else {
            throw ValidationError.emptyArea
        }
        return areaId
    }
    
    static func validate(addressName: String?) throws -> String {
        guard let addressName = addressName, !addressName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyAddress
        }
        return addressName
    }
    
    static func validate(streetName: String?) throws -> String {
        guard let streetName = streetName, !streetName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyStreet
        }
        return streetName
    }
    
    static func validate(buildingNum: String?) throws -> String {
        guard let buildingNum = buildingNum, !buildingNum.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyBuildingNum
        }
        return buildingNum
    }
    
    static func validate(department: String?) throws -> String {
        guard let department = department, !department.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyStreet
        }
        return department
        
    }
    static func validate(addressType: String?) throws -> String {
        guard let addressType = addressType, !addressType.trimWhiteSpace().isEmpty else {
            throw ValidationError.addressType
        }
        return addressType
    }
    static func validate(addressDetails: String?) throws -> String {
        guard let addressDetails = addressDetails, !addressDetails.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyAddressDetails
        }
        return addressDetails
    }
    
    static func validate(emptyLocation: String?) throws -> String {
        guard let emptyLocation = emptyLocation, !emptyLocation.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyLocation
        }
        return emptyLocation
    }
    
    static func validateLocation(address: String?, lat: Double?, long: Double?) throws -> (address: String, lat: Double, long: Double) {
        guard let address = address, let lat = lat, let long = long else {
            throw ValidationError.emptyLocation
        }
        return (address, lat, long)
    }
    
    //MARK: - Images -
    static func validate(profilePicture: String?) throws -> String {
        guard let profilePicture = profilePicture, !profilePicture.isEmpty else {
            throw ValidationError.profilePicture
        }
        return profilePicture
    }
    static func validate(licensePicture: Data?) throws -> Data {
        guard let licensePicture = licensePicture else {
            throw ValidationError.licensePicture
        }
        return licensePicture
    }
    static func validate(productPicture: Data?) throws -> Data {
        guard let productPicture = productPicture else {
            throw ValidationError.productPicture
        }
        return productPicture
    }
    
    //MARK: - Cars -
    @discardableResult
    static func validate(carPicture: Data?) throws -> Data {
        guard let carPicture = carPicture else {
            throw ValidationError.carPicture
        }
        return carPicture
    }
    @discardableResult
    static func validate(carPlate: String?) throws -> String {
        guard let carPlate = carPlate, !carPlate.trimWhiteSpace().isEmpty else {
            throw ValidationError.carPlate
        }
        return carPlate
    }
    
    @discardableResult
    static func validate(carModel: String?) throws -> String {
        guard let carModel = carModel , !carModel.trimWhiteSpace().isEmpty  else {
            throw ValidationError.carModel
        }
        return carModel
    }
    
    @discardableResult
    static func validate(carType: String?) throws -> String {
        guard let carType = carType, !carType.trimWhiteSpace().isEmpty else {
            throw ValidationError.carType
        }
        return carType
    }
    
    //MARK: - Date -
    static func validate(age: String?) throws -> String {
        guard let age = age, !age.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyAge
        }
        guard age.toInt() > 0 else {
            throw ValidationError.youngAge
        }
        return age
    }
    static func validate(oldDate: String?) throws -> String {
        guard let oldDate = oldDate, let date = oldDate.toDate() else {
            throw ValidationError.emptyDate
        }
        guard date.isBeforeNow() else {
            throw ValidationError.notOldDate
        }
        return oldDate
    }
    static func validate(newDate: String?) throws -> String {
        guard let newDate = newDate, let date = newDate.toDate() else {
            throw ValidationError.emptyDate
        }
        guard date.isBeforeNow() else {
            throw ValidationError.notNewDate
        }
        return newDate
    }
    static func validate(date: String?) throws -> String {
        guard let date = date, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyDate
        }
        return date
    }
    
    //MARK: - Message -
    static func validate(title: String?) throws -> String {
        guard let title = title, !title.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyTitle
        }
        return title
    }
    static func validate(titleType: String?) throws -> String {
        guard let titleType = titleType, !titleType.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyTitleType
        }
        return titleType
    }
  
    static func validate(complaintTitle: String?) throws -> String {
        guard let complaintTitle = complaintTitle, !complaintTitle.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyComplaintTitle
        }
        return complaintTitle
    }
    
    static func validate(complaintDetails: String?) throws -> String {
        guard let complaintDetails = complaintDetails, !complaintDetails.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyComplaintDetails
        }
        return complaintDetails
    }
    
    //MARK: - Bank -
    @discardableResult
    static func validate(bankAccountHolder: String?) throws -> String {
        guard let bankAccountHolder = bankAccountHolder, !bankAccountHolder.trimWhiteSpace().isEmpty else {
            throw ValidationError.bankAccountHolder
        }
        return bankAccountHolder
    }
    
    @discardableResult
    static func validate(bankName: String?) throws -> String {
        guard let bankName = bankName, !bankName.trimWhiteSpace().isEmpty else {
            throw ValidationError.bankName
        }
        return bankName
    }
    static func validate(fromBankName: String?) throws -> String {
        guard let fromBankName = fromBankName, !fromBankName.trimWhiteSpace().isEmpty else {
            throw ValidationError.fromBankName
        }
        return fromBankName
    }
    
    @discardableResult
    static func validate(bankAccountNumber: String?) throws -> String {
        guard let bankAccountNumber = bankAccountNumber, !bankAccountNumber.trimWhiteSpace().isEmpty else {
            throw ValidationError.bankAccountNumber
        }
        return bankAccountNumber
    }
    static func validate(bankTransferImage: Data?) throws -> Data {
        guard let bankTransferImage = bankTransferImage else {
            throw ValidationError.bankTransferImage
        }
        return bankTransferImage
    }
    
    @discardableResult
    static func validate(iban: String?) throws -> String {
        
        guard let iban = iban?.trimWhiteSpace(),
              !iban.isEmpty else {
            throw ValidationError.iban
        }

        let saudiIbanRegex = "^SA\\d{22}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", saudiIbanRegex)

        guard predicate.evaluate(with: iban) else {
            throw ValidationError.invalidSaudiIBAN
        }

        return iban
    }
    
    //MARK: - Categories -
    static func validate(categoryId: Int?) throws -> Int {
        guard let categoryId = categoryId else {
            throw ValidationError.emptyCategory
        }
        return categoryId
    }
    static func validate(priceBefore: String?, priceAfter: String?) throws -> (priceBefore: String, priceAfter: String) {
        guard let priceBefore = priceBefore, !priceBefore.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyPriceBefore
        }
        guard let priceAfter = priceAfter, !priceAfter.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyPriceAfter
        }
        guard priceBefore.toDouble() > priceAfter.toDouble() else {
            throw ValidationError.priceBeforeSmallThanPriceAfter
        }
        return (priceBefore, priceAfter)
        
    }
    static func validate(description: String?) throws -> String {
        guard let description = description, !description.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyDescription
        }
        return description
    }
    
    //MARK: - Wallet -
    
    static func validateWalletRecharge(amount: String?) -> Result<Double, ValidationError> {
        
        guard var amount = amount?.trimWhiteSpace(), !amount.isEmpty else {
            return .failure(.emptyAmount)
        }
        
        let arabicNumbers = ["٠":"0","١":"1","٢":"2","٣":"3","٤":"4","٥":"5","٦":"6","٧":"7","٨":"8","٩":"9"]
        arabicNumbers.forEach { amount = amount.replacingOccurrences(of: $0.key, with: $0.value) }
        
        amount = amount.replacingOccurrences(of: " ", with: "")
        
        let allowed = CharacterSet(charactersIn: "0123456789.,")
        amount = String(amount.unicodeScalars.filter { allowed.contains($0) })
        
        if amount.filter({ $0 == "." }).count > 1 {
            amount = amount.replacingOccurrences(of: ".", with: "")
        }
        if amount.filter({ $0 == "," }).count > 1 {
            amount = amount.replacingOccurrences(of: ",", with: "")
        }
        
        amount = amount.replacingOccurrences(of: ",", with: ".")
        
        guard let value = Double(amount), value > 0 else {
            return .failure(.invalidAmount)
        }
        
        return .success(value)
    }
    
    //MARK: - Signup -

    static func validate(identityNumber: String?) throws -> String {
        guard let identityNumber = identityNumber, !identityNumber.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyIdentityNumber
        }
        return identityNumber
    }

    static func validate(vehicleSerialNumber: String?) throws -> String {
        guard let vehicleSerialNumber = vehicleSerialNumber, !vehicleSerialNumber.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyVehicleSerialNumber
        }
        let trimmed = vehicleSerialNumber.trimWhiteSpace()
        guard trimmed.count >= 4, trimmed.count <= 17,
              trimmed.allSatisfy({ $0.isNumber }) else {
            throw ValidationError.invalidVehicleSerialNumber
        }
        return trimmed
    }

    static func validate(delegateCompanyId: Int?) throws -> Int {
        guard let id = delegateCompanyId else { throw ValidationError.emptyDelegateCompany }
        return id
    }

    static func validate(providerId: Int?) throws -> Int {
        guard let id = providerId else { throw ValidationError.emptyProvider }
        return id
    }

    static func validate(carTypeId: Int?) throws -> Int {
        guard let id = carTypeId else { throw ValidationError.carType }
        return id
    }

    static func validate(carModelId: Int?) throws -> Int {
        guard let id = carModelId else { throw ValidationError.carModel }
        return id
    }

    static func validate(neighborhoodIds: [Int]?) throws -> [Int] {
        guard let ids = neighborhoodIds, !ids.isEmpty else { throw ValidationError.emptyArea }
        return ids
    }

    static func validate(driverIdentityImage: String?) throws -> String {
        guard let data = driverIdentityImage, !data.isEmpty else { throw ValidationError.emptyDriverIdentityImage }
        return data
    }

    static func validate(vehicleOperatingLicenseImage: String?) throws -> String {
        guard let data = vehicleOperatingLicenseImage, !data.isEmpty else { throw ValidationError.emptyVehicleOperatingLicenseImage }
        return data
    }

    static func validate(nationalIdentityImage: String?) throws -> String {
        guard let data = nationalIdentityImage, !data.isEmpty else { throw ValidationError.emptyNationalIdentityImage }
        return data
    }

    static func validate(vehicleRegistrationImage: String?) throws -> String {
        guard let data = vehicleRegistrationImage, !data.isEmpty else { throw ValidationError.emptyVehicleRegistrationImage }
        return data
    }

    static func validate(drivingLicenseImage: String?) throws -> String {
        guard let data = drivingLicenseImage, !data.isEmpty else { throw ValidationError.emptyDrivingLicenseImage }
        return data
    }

    static func validate(vehicleInsuranceImage: String?) throws -> String {
        guard let data = vehicleInsuranceImage, !data.isEmpty else { throw ValidationError.emptyVehicleInsuranceImage }
        return data
    }

    static func validate(periodicCheckUpImage: String?) throws -> String {
        guard let data = periodicCheckUpImage, !data.isEmpty else { throw ValidationError.emptyPeriodicCheckUpImage }
        return data
    }

    static func validate(otherImage: String?) throws -> String {
        guard let data = otherImage, !data.isEmpty else { throw ValidationError.emptyOtherImage }
        return data
    }

    static func validate(vehicleFrontImage: String?) throws -> String {
        guard let data = vehicleFrontImage, !data.isEmpty else { throw ValidationError.emptyVehicleFrontImage }
        return data
    }

    static func validate(vehicleBackImage: String?) throws -> String {
        guard let data = vehicleBackImage, !data.isEmpty else { throw ValidationError.emptyVehicleBackImage }
        return data
    }

    static func validate(vehicleRightImage: String?) throws -> String {
        guard let data = vehicleRightImage, !data.isEmpty else { throw ValidationError.emptyVehicleRightImage }
        return data
    }

    static func validate(vehicleLeftImage: String?) throws -> String {
        guard let data = vehicleLeftImage, !data.isEmpty else { throw ValidationError.emptyVehicleLeftImage }
        return data
    }

    static func validate(driverIdentityEndDate: String?) throws -> String {
        guard let date = driverIdentityEndDate, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyDriverIdentityEndDate
        }
        return date
    }

    static func validate(vehicleOperatingLicenseEndDate: String?) throws -> String {
        guard let date = vehicleOperatingLicenseEndDate, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyVehicleOperatingLicenseEndDate
        }
        return date
    }

    static func validate(identityImageEndDate: String?) throws -> String {
        guard let date = identityImageEndDate, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyIdentityImageEndDate
        }
        return date
    }

    static func validate(vehicleRegistrationLicenseDate: String?) throws -> String {
        guard let date = vehicleRegistrationLicenseDate, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyVehicleRegistrationLicenseDate
        }
        return date
    }

    static func validate(drivingLicenseEndDate: String?) throws -> String {
        guard let date = drivingLicenseEndDate, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyDrivingLicenseEndDate
        }
        return date
    }

    static func validate(vehicleInsuranceEndDate: String?) throws -> String {
        guard let date = vehicleInsuranceEndDate, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyVehicleInsuranceEndDate
        }
        return date
    }

    static func validate(periodicCheckUpDate: String?) throws -> String {
        guard let date = periodicCheckUpDate, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyPeriodicCheckUpDate
        }
        return date
    }

    //MARK: - Provider Signup -

    @discardableResult
    static func validate(storeName: String?) throws -> String {
        guard let storeName = storeName, !storeName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyStoreName
        }
        guard storeName.count > 1 else {
            throw ValidationError.shortStoreName
        }
        guard storeName.count < 101 else {
            throw ValidationError.longStoreName
        }
        return storeName
    }

    static func validate(commercialNumber: String?) throws -> String {
        guard let commercialNumber = commercialNumber, !commercialNumber.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyCommercialNumber
        }
        return commercialNumber
    }

    static func validate(taxNumber: String?) throws -> String {
        guard let taxNumber = taxNumber, !taxNumber.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyTaxNumber
        }
        return taxNumber
    }

    static func validate(establishmentName: String?) throws -> String {
        guard let establishmentName = establishmentName, !establishmentName.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyEstablishmentName
        }
        return establishmentName
    }

    static func validate(providerIdentityImage: Data?) throws -> Data {
        guard let data = providerIdentityImage else {
            throw ValidationError.emptyProviderIdentityImage
        }
        return data
    }

    static func validate(providerCommercialImage: Data?) throws -> Data {
        guard let data = providerCommercialImage else {
            throw ValidationError.emptyCommercialImage
        }
        return data
    }

    static func validate(providerPermissionImage: Data?) throws -> Data {
        guard let data = providerPermissionImage else {
            throw ValidationError.emptyPermissionImage
        }
        return data
    }

    static func validate(commercialEndDate: String?) throws -> String {
        guard let date = commercialEndDate, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyCommercialEndDate
        }
        return date
    }

    static func validate(permissionEndDate: String?) throws -> String {
        guard let date = permissionEndDate, !date.trimWhiteSpace().isEmpty else {
            throw ValidationError.emptyPermissionEndDate
        }
        return date
    }

    static func validate(amount: String?) throws -> String{
        
        guard var amount = amount?.trimWhiteSpace(), !amount.isEmpty else {
            throw ValidationError.withdrawAmount
        }
        
        guard let value = Int(amount), value > 0 else {
            throw ValidationError.invalidAmount
        }
        
        return amount
    }
        
    
    
}

