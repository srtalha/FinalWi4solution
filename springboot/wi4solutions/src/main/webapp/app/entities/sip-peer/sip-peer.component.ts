import { Component, OnInit, OnDestroy } from '@angular/core';
import { HttpErrorResponse, HttpResponse } from '@angular/common/http';
import { Subscription } from 'rxjs';
import { JhiEventManager, JhiAlertService } from 'ng-jhipster';

import { ISipPeer } from 'app/shared/model/sip-peer.model';
import { Principal } from 'app/core';
import { SipPeerService } from './sip-peer.service';

@Component({
    selector: 'jhi-sip-peer',
    templateUrl: './sip-peer.component.html'
})
export class SipPeerComponent implements OnInit, OnDestroy {
    sipPeers: ISipPeer[];
    currentAccount: any;
    eventSubscriber: Subscription;
    error: any;
    success: any;

    constructor(
        private sipPeerService: SipPeerService,
        private jhiAlertService: JhiAlertService,
        private eventManager: JhiEventManager,
        private principal: Principal
    ) {}

    loadAll() {
        this.sipPeerService
            .query({
                peerType: 'CARRIER'
            })
            .subscribe(
                (res: HttpResponse<ISipPeer[]>) => {
                    this.sipPeers = res.body;
                },
                (res: HttpErrorResponse) => this.onError(res.message)
            );
    }

    ngOnInit() {
        this.loadAll();
        this.principal.identity().then(account => {
            this.currentAccount = account;
        });
        this.registerChangeInSipPeers();
    }

    ngOnDestroy() {
        this.eventManager.destroy(this.eventSubscriber);
    }

    setActive(sipPeer, isActivated) {
        sipPeer.status = isActivated;

        this.sipPeerService.update(sipPeer).subscribe(response => {
            if (response.status === 200) {
                this.error = null;
                this.success = 'OK';
                this.loadAll();
            } else {
                this.success = null;
                this.error = 'ERROR';
            }
        });
    }

    trackId(index: number, item: ISipPeer) {
        return item.id;
    }

    registerChangeInSipPeers() {
        this.eventSubscriber = this.eventManager.subscribe('sipPeerListModification', response => this.loadAll());
    }

    private onError(errorMessage: string) {
        this.jhiAlertService.error(errorMessage, null, null);
    }
}
