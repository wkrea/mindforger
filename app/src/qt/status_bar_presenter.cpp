/*
 status_bar_presenter.cpp     MindForger thinking notebook

 Copyright (C) 2016-2018 Martin Dvorak <martin.dvorak@mindforger.com>

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.
*/
#include "status_bar_presenter.h"

using namespace std;

namespace m8r {

StatusBarPresenter::StatusBarPresenter(const StatusBarView* view, Mind* mind)
    : view(view), mind(mind)
{
}

void StatusBarPresenter::showInfo(const QString& message)
{
    view->showInfo(message);
}

void StatusBarPresenter::showWarning(const QString& message)
{
    view->showWarning(message);
}

void StatusBarPresenter::showError(const QString& message)
{
    view->showError(message);
}

void StatusBarPresenter::showMindStatistics()
{
    const QLocale& cLocale = QLocale::c(); // "C" seems to be a default locale

    // IMPROVE string builder
    // IMPROVE const delimiter "    "

    // use %L1 to localize
    // use locale to: 1000 > 1,000
    status.clear();

    status.append(" ");
    switch(Configuration::getInstance().getMindState()) {
    case Configuration::MindState::THINKING:
        status.append("Thinking");
        break;
    case Configuration::MindState::DREAMING:
        status.append("Dreaming");
        break;
    case Configuration::MindState::SLEEPING:
        status.append("Sleeping");
        break;
    }
    status.append("    ");

    switch(Configuration::getInstance().getActiveRepository()->getType()) {
    case Repository::RepositoryType::MINDFORGER:
        status.append("MF");
        break;
    case Repository::RepositoryType::MARKDOWN:
        status.append("MD");
        break;
    }
    switch(Configuration::getInstance().getActiveRepository()->getMode()) {
    case Repository::RepositoryMode::REPOSITORY:
        status.append(" repository    ");
        break;
    case Repository::RepositoryMode::FILE:
        status.append(" file    ");
        break;
    }

    status += cLocale.toString(mind->remind().getOutlinesCount());
    status.append(" outlines    ");
    status += cLocale.toString(mind->remind().getNotesCount());
    status.append(" notes    ");
    status += cLocale.toString(mind->getTriplesCount());
    status.append(" triples    ");
    status += cLocale.toString(mind->remind().getOutlineMarkdownsSize());
    status.append(" bytes    ");
    if(mind->isTimeScopeEnabled()) {
        status.append("scope:");
        status.append(mind->getTimeScopeAsString().c_str());
    }

    view->showInfo(status);
}

} // namespace