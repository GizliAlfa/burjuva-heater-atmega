#ifndef MATERIALMANAGER_H
#define MATERIALMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QStandardPaths>

class MaterialManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList materials READ materials NOTIFY materialsChanged)
    Q_PROPERTY(QVariantMap selectedMaterial READ selectedMaterial NOTIFY selectedMaterialChanged)

public:
    explicit MaterialManager(QObject *parent = nullptr);
    
    QVariantList materials() const { return m_materials; }
    QVariantMap selectedMaterial() const { return m_selectedMaterial; }
    
    Q_INVOKABLE void addMaterial(const QString &name, int temperature, int flowRate, int duration);
    Q_INVOKABLE void removeMaterial(int index);
    Q_INVOKABLE void updateMaterial(int index, const QString &name, int temperature, int flowRate, int duration);
    Q_INVOKABLE void selectMaterial(int index);
    
signals:
    void materialsChanged();
    void selectedMaterialChanged();
    
private:
    void loadMaterials();
    void saveMaterials();
    QString getDataFilePath();
    
    QVariantList m_materials;
    QVariantMap m_selectedMaterial;
};

#endif // MATERIALMANAGER_H
