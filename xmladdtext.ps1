<# Instruções:
	xmlFilePathPT e xmlFilePathEN recebem o diretório dos seus arquivos XML em portugues e ingles.
	Caso seja necessário adicionar localizações em outras linguas:
	- Adicione outro diretório:
		Ex:
		 [string]$xmlFilePathFR = "xml_em_frances.xml"
	- Adicione outro parametro para texto
		Ex:
		  [string]$textFr 
	- Ao final deste script, adicione uma chamada da função AddTextToXml passando os parametros da linguagem escolhida.
#>
param (
	
    [string]$xmlFilePathPT = "",
    [string]$xmlFilePathEN = "",
    [string]$name, # O parametro 'name' é igual para todos.
    [string]$textPt,
    [string]$textEn
)

function AddTextToXml ($xmlFilePath, $name, $text) {
    # Checa se arquivo XML existe
    if (-not (Test-Path -Path $xmlFilePath -PathType Leaf)) {
        Write-Host "Error: XML não encontrado em '$xmlFilePath'."
        exit 1
    }

    # Carregar XML
    try {
        [xml]$xmlContent = Get-Content -Path $xmlFilePath
    }
    catch {
        Write-Host "Erro carregando XML: $_"
        exit 1
    }

    # Encontrar a tag <texts>
    $textsElement = $xmlContent.SelectNodes('//texts').Item(0)

    # Cria novo elemento no XML
    try {
        $newElement = $xmlContent.CreateElement("text")
        $newElement.SetAttribute("name", $name)
        $newElement.InnerXml = $text
    }
    catch {
        Write-Host "Erro ao ler XML element: $_"
        exit 1
    }

    # Adiciona novo elemento na tag <texts> no xml
    try {
        $textsElement.AppendChild($newElement)
    }
    catch {
        Write-Host "Erro adicionando texto <texts>: $_"
        exit 1
    }

    # Salva nova versão do XML
    try {
        $xmlContent.Save($xmlFilePath)
        Write-Host "Localizacao adicionada em '$xmlFilePath'!"
    }
    catch {
        Write-Host "Erro salvando XML file: $_"
        exit 1
    }
}

do {
    
    $name = Read-Host "Nome da tag"
  
    $textPt = Read-Host "Texto em portugues"
    
    $textEn = Read-Host "Texto em ingles"
    
    AddTextToXml -xmlFilePath $xmlFilePathPT -name $name -text "$textPt"
    AddTextToXml -xmlFilePath $xmlFilePathEN -name $name -text "$textEn" 
	#Adicione um chamado da função AddTextToXml passando a linguagem escolhida aqui.
    
    $addMore = Read-Host "Quer adicionar mais? (y/n)"
}
while ($addMore -eq "y")
