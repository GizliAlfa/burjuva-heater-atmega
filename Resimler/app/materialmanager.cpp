#include "materialmanager.h"
#include <QDir>
#include <QDebug>

MaterialManager::MaterialManager(QObject *parent)
    : QObject(parent)
{
    loadMaterials();
    
    // İlk başlatmada varsayılan materyaller ekle
    if (m_materials.isEmpty()) {
        addMaterial("PET", 180, 45, 30);
        addMaterial("PP", 160, 40, 25);
        addMaterial("PE", 140, 35, 20);
    }
}

void MaterialManager::addMaterial(const QString &name, int temperature, int flowRate, int duration)
{
    QVariantMap material;
    material["name"] = name;
    material["temperature"] = temperature;
    material["flowRate"] = flowRate;
    material["duration"] = duration;
    
    m_materials.append(material);
    emit materialsChanged();
    saveMaterials();
}

void MaterialManager::removeMaterial(int index)
{
    if (index >= 0 && index < m_materials.size()) {
        m_materials.removeAt(index);
        emit materialsChanged();
        saveMaterials();
        
        // Eğer silinen materyal seçiliyse, seçimi temizle
        if (!m_materials.isEmpty() && m_selectedMaterial.isEmpty()) {
            selectMaterial(0);
        }
    }
}

void MaterialManager::updateMaterial(int index, const QString &name, int temperature, int flowRate, int duration)
{
    if (index >= 0 && index < m_materials.size()) {
        QVariantMap material;
        material["name"] = name;
        material["temperature"] = temperature;
        material["flowRate"] = flowRate;
        material["duration"] = duration;
        
        m_materials[index] = material;
        
        // Eğer güncellenen materyal seçiliyse, seçili materyali de güncelle
        if (m_selectedMaterial.value("name") == m_materials[index].toMap().value("name")) {
            m_selectedMaterial = material;
            emit selectedMaterialChanged();
        }
        
        emit materialsChanged();
        saveMaterials();
    }
}

void MaterialManager::selectMaterial(int index)
{
    if (index >= 0 && index < m_materials.size()) {
        m_selectedMaterial = m_materials[index].toMap();
        emit selectedMaterialChanged();
        saveMaterials(); // Seçimi de kaydet
    }
}

void MaterialManager::loadMaterials()
{
    QString filePath = getDataFilePath();
    QFile file(filePath);
    
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "Could not open materials file for reading:" << filePath;
        return;
    }
    
    QByteArray data = file.readAll();
    file.close();
    
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (!doc.isObject()) {
        qDebug() << "Invalid JSON format";
        return;
    }
    
    QJsonObject obj = doc.object();
    
    // Load materials
    QJsonArray materialsArray = obj["materials"].toArray();
    m_materials.clear();
    
    for (const QJsonValue &value : materialsArray) {
        QJsonObject matObj = value.toObject();
        QVariantMap material;
        material["name"] = matObj["name"].toString();
        material["temperature"] = matObj["temperature"].toInt();
        material["flowRate"] = matObj["flowRate"].toInt();
        material["duration"] = matObj["duration"].toInt();
        m_materials.append(material);
    }
    
    // Load selected material
    QJsonObject selectedObj = obj["selectedMaterial"].toObject();
    if (!selectedObj.isEmpty()) {
        m_selectedMaterial["name"] = selectedObj["name"].toString();
        m_selectedMaterial["temperature"] = selectedObj["temperature"].toInt();
        m_selectedMaterial["flowRate"] = selectedObj["flowRate"].toInt();
        m_selectedMaterial["duration"] = selectedObj["duration"].toInt();
    }
    
    emit materialsChanged();
    emit selectedMaterialChanged();
}

void MaterialManager::saveMaterials()
{
    QJsonObject obj;
    
    // Save materials
    QJsonArray materialsArray;
    for (const QVariant &var : m_materials) {
        QVariantMap material = var.toMap();
        QJsonObject matObj;
        matObj["name"] = material["name"].toString();
        matObj["temperature"] = material["temperature"].toInt();
        matObj["flowRate"] = material["flowRate"].toInt();
        matObj["duration"] = material["duration"].toInt();
        materialsArray.append(matObj);
    }
    obj["materials"] = materialsArray;
    
    // Save selected material
    if (!m_selectedMaterial.isEmpty()) {
        QJsonObject selectedObj;
        selectedObj["name"] = m_selectedMaterial["name"].toString();
        selectedObj["temperature"] = m_selectedMaterial["temperature"].toInt();
        selectedObj["flowRate"] = m_selectedMaterial["flowRate"].toInt();
        selectedObj["duration"] = m_selectedMaterial["duration"].toInt();
        obj["selectedMaterial"] = selectedObj;
    }
    
    QJsonDocument doc(obj);
    
    QString filePath = getDataFilePath();
    QFile file(filePath);
    
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Could not open materials file for writing:" << filePath;
        return;
    }
    
    file.write(doc.toJson());
    file.close();
    
    qDebug() << "Materials saved to:" << filePath;
}

QString MaterialManager::getDataFilePath()
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QDir dir(dataPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    return dataPath + "/materials.json";
}
