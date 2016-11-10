#ifndef WHIRLPOOLHASH_H
#define WHIRLPOOLHASH_H

#include <QObject>
#include <QVariantList>
#include <QMutex>

#include "hash/whirlpool.h"

class WhirlpoolHash : public QObject
{
    Q_OBJECT
public:
    explicit WhirlpoolHash(QObject *parent = 0);

   Q_INVOKABLE QVariantList hash(const QString& str);
private:
    whirlpool_ctx w;
    QMutex mutex;
};

#endif // WHIRLPOOLHASH_H
