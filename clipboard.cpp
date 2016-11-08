#include "clipboard.h"

#include <QGuiApplication>
#include <QClipboard>

Clipboard::Clipboard(QObject *parent) : QObject(parent)
{

}

void Clipboard::postText(const QString& text)
{
    QClipboard* clipboard = QGuiApplication::clipboard();
    clipboard->setText(text);
}
