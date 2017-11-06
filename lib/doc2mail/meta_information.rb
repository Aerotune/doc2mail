module Doc2Mail
  class MetaInformation
    # Note that all attributes are strings
    # Keys keep their spelling and format from [Webservice API dokumentation.pdf]
    attr_accessor \
      :documenttype, # Eg. "Dogndata1"
      # [Webservice API dokumentation.pdf] page 3
      # "KMDPRINT" - printes på papir hos KMD
      # "EBOKS" - sendes til digital post (offentlig kunde) eller e-boks (privat kunde)
      # "EBOKSKMDPRINT" - sendes til digital post/e-boks, hvis modtageren er tilmeldt, ellers printes det
      # "LOKALPRINT" - sendes ikke hverken digitalt eller til print. Anvendes fx ved arkivering i doc2archive
      # "NONE" - synonym for LOKALPRINT
      :destination,
      :title, # max 50 chars
      :receivertype, # "CPR", "CVR"
      :receiver, # CPR-nummer eller CVR-nummer som string
      :system, # max 50 chars
      :archive, # Angiver om doc2archive (tidl. kaldt OnDemand) arkivering skal anvendes.
      :odsagsident, # Sagsident mhp arkivering i doc2archive
      :odfagomraade, # Fagområde mhp arkivering i doc2archive
      :odbeskrivelse, # Beskrivelse mhp arkivering i doc2archive
      :deliverydocumentback, # "true", "false" Beskriver om man ønsker en kopi af det leverede dokument tilbage.
      # Kan angive en string value der har betydning for det system der aflevere dokument.
      # Bruges til sporbarhed, men anvendes ikke i Doc2Mail.
      # Documentid findes i dkalmetadata.xml filen som dannes i Digital Post ved retursvar.
      :documentid,
      :addReturnAddress, # Angiver om den konfigurerede retur adresse skal tilføjes til dokumentet.
      :FESDDocumentId, # Angiver dokument id fra ESDH som tekst værdi
      :FESDActorId, # Angiver afsender id fra ESDH som tekst værdi
      :FESDCaseId, # Angiver hvilken ESDH sag dokumentet tilhører
      :FESDClassification, # Beskriver ESDH klassifikation af sagen
      # Angiver med tal værdi mulighed/regel for DKAL svar (overordnet bestemt af dokument type)
      # "1" = Intet svar
      # "2" = Standard svar
      # "3" = Et brugervalgt svar.
      :responseType,
      :responseThread, # Angiver den tråd id DKAL svar skal benytte
      :responseAddress, # Angiver hvilken DKAL svar postkasse der skal anvendes
      :responseSubject, # Angiver hvilket DKAL svar emne der skal anvendes
      :MailPriority, # "A" = Prioritaire, "B" = Economique,
      # Attentionformat: En XML-streng, der opfyldet skemaet for attentionformatet.
      # Må ikke angives sammen med nogen af de øvrige attentionformatparametre
      :AttXmlIndhold,
      :AttPNummer, # Attentionformat: P-nummer. Skal bruges sammen med et CVR-nummer
      :AttEmail, # Attentionformat: Email. Skal bruges sammen med et CVR-nummer
      :AttEnhedsNavn, # Attentionformat: Organisatorisk enhedsnavn. Skal bruges sammen med et CVR-nummer
      :AttPrimaerKlasse, # Attentionformat: Personnavn. Skal bruges sammen med et CVR-nummer
      :AttPrimaerKlasse, # Attentionformat: Primærklasse-id. Skal bruges sammen med et CVR-nummer
      :AttSekundaerKlasse, # Attentionformat: Sekundærklasse-id. Skal bruges sammen med et CVR-nummer
      :PostalDestinationCountry, # ISO-landekode på 2 bogstaver eg. DK
      :apiVersion

    def initialize(options = {})
      options.each do |variable_name, variable_value|
        instance_variable_set("@#{variable_name}", variable_value)
      end
    end

    def to_a
      result = []

      instance_variables.each do |instance_variable|
        name = instance_variable[1..-1]
        value = instance_variable_get(instance_variable).to_s

        case name
        when 'title', 'system' then value = value[0...50] # Max 50 characters
        end
        result << { 'Name' => name, 'Value' => value } unless value == ''
      end

      result
    end
  end
end
